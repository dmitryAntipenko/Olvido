//
//  OGGameScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene.h"
#import "OGCollisionBitMask.h"
#import "OGTouchControlInputNode.h"
#import "OGConstants.h"
#import "OGGameSceneConfiguration.h"
#import "OGEnemyConfiguration.h"
#import "OGCameraController.h"
#import "OGContactNotifiableType.h"

#import "OGPlayerEntity.h"
#import "OGRenderComponent.h"
#import "OGLockComponent.h"
#import "OGPhysicsComponent.h"
#import "OGMovementComponent.h"
#import "OGIntelligenceComponent.h"
#import "OGAnimationComponent.h"
#import "OGMessageComponent.h"
#import "OGTransitionComponent.h"
#import "OGWeaponComponent.h"
#import "OGInventoryComponent.h"

#import "OGPlayerEntity.h"
#import "OGEnemyEntity.h"
#import "OGDoorEntity.h"
#import "OGWeaponEntity.h"
#import "OGKey.h"

#import "OGInventoryBarNode.h"

#import "OGBeforeStartLevelState.h"
#import "OGStoryConclusionLevelState.h"
#import "OGGameLevelState.h"
#import "OGPauseLevelState.h"
#import "OGCompleteLevelState.h"
#import "OGDeathLevelState.h"

#import "OGLevelManager.h"
#import "OGAnimationComponent.h"
#import "OGAnimationState.h"

NSString *const kOGGameSceneDoorsNodeName = @"doors";
NSString *const kOGGameSceneItemsNodeName = @"items";
NSString *const kOGGameSceneWeaponNodeName = @"weapon";
NSString *const kOGGameSceneKeysNodeName = @"keys";
NSString *const kOGGameSceneSourceNodeName = @"source";
NSString *const kOGGameSceneDestinationNodeName = @"destination";
NSString *const kOGGameSceneDoorLockedKey = @"locked";

NSString *const kOGGameScenePlayerInitialPointNodeName = @"player_initial_point";

NSString *const kOGGameSceneDoorKeyPrefix = @"key";

NSString *const kOGGameScenePauseScreenNodeName = @"OGPauseScreen.sks";
NSString *const kOGGameSceneGameOverScreenNodeName = @"OGGameOverScreen.sks";

CGFloat const kOGGameScenePauseSpeed = 0.0;
CGFloat const kOGGameScenePlayeSpeed = 1.0;

CGFloat const kOGGameSceneDoorOpenDistance = 50.0;

NSUInteger const kOGGameSceneZSpacePerCharacter = 100;

@interface OGGameScene ()

@property (nonatomic, strong) SKNode *currentRoom;
@property (nonatomic, strong) OGCameraController *cameraController;
@property (nonatomic, strong) OGPlayerEntity *player;
@property (nonatomic, strong) OGGameSceneConfiguration *sceneConfiguration;
@property (nonatomic, strong) GKStateMachine *stateMachine;
@property (nonatomic, strong) SKReferenceNode *pauseScreenNode;
@property (nonatomic, strong) SKReferenceNode *gameOverScreenNode;
@property (nonatomic, strong) OGInventoryBarNode *inventoryBarNode;

@property (nonatomic, assign) CGFloat lastUpdateTimeInterval;

@property (nonatomic, strong) NSMutableOrderedSet<GKEntity *> *entities;
@property (nonatomic, strong) NSMutableArray<GKComponentSystem *> *componentSystems;

@end

@implementation OGGameScene

@synthesize name = _name;

#pragma mark - Initializer

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        _inventoryBarNode = [OGInventoryBarNode node];
        
        _sceneConfiguration = [OGGameSceneConfiguration gameSceneConfigurationWithFileName:_name];
        
        _cameraController = [[OGCameraController alloc] init];
        
        _stateMachine = [[GKStateMachine alloc] initWithStates:@[
            [OGStoryConclusionLevelState stateWithLevelScene:self],
            [OGBeforeStartLevelState stateWithLevelScene:self],
            [OGGameLevelState stateWithLevelScene:self],
            [OGPauseLevelState stateWithLevelScene:self],
            [OGCompleteLevelState stateWithLevelScene:self],
            [OGDeathLevelState stateWithLevelScene:self]
        ]];
        
        _entities = [[NSMutableOrderedSet alloc] init];
        
        _componentSystems = [[NSMutableArray alloc] initWithObjects:
                             [[GKComponentSystem alloc] initWithComponentClass:OGAnimationComponent.self],
                             [[GKComponentSystem alloc] initWithComponentClass:OGMovementComponent.self],
                             [[GKComponentSystem alloc] initWithComponentClass:OGIntelligenceComponent.self],
                             [[GKComponentSystem alloc] initWithComponentClass:OGLockComponent.self],
                             [[GKComponentSystem alloc] initWithComponentClass:OGMessageComponent.self],
                             [[GKComponentSystem alloc] initWithComponentClass:OGWeaponComponent.self],
                             nil];
        
        _pauseScreenNode = [[SKReferenceNode alloc] initWithFileNamed:kOGGameScenePauseScreenNodeName];
        _gameOverScreenNode = [[SKReferenceNode alloc] initWithFileNamed:kOGGameSceneGameOverScreenNodeName];
    }
    
    return self;
}

#pragma mark - Scene contents

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.sceneDelegate = (id<OGGameSceneDelegate>) [OGLevelManager sharedInstance];
    
    self.physicsWorld.contactDelegate = self;
    self.lastUpdateTimeInterval = 0.0;
    
    self.currentRoom = [self childNodeWithName:self.sceneConfiguration.startRoom];
    [self createSceneContents];

    [self createCameraNode];
    [self createInventoryBar];
    
    OGTouchControlInputNode *inputNode = [[OGTouchControlInputNode alloc] initWithFrame:self.frame thumbStickNodeSize:[self thumbStickNodeSize]];
    inputNode.size = self.size;
    inputNode.inputSourceDelegate = (id<OGControlInputSourceDelegate>) self.player.input;
    inputNode.position = CGPointZero;
    [self.camera addChild:inputNode];
    
    [self.stateMachine enterState:[OGGameLevelState class]];
}

- (CGSize)thumbStickNodeSize
{
    return CGSizeMake(200.0, 200.0);
}

#pragma mark - Scene Creation

- (void)createSceneContents
{
    [self createPlayer];
    [self createEnemies];
    [self createDoors];
    [self createSceneItems];
}

- (void)createCameraNode
{
    SKCameraNode *camera = [[SKCameraNode alloc] init];
    self.camera = camera;
    self.cameraController.camera = camera;
    [self addChild:camera];
    
    self.cameraController.target = self.player.render.node;
    
    [self.cameraController moveCameraToNode:self.currentRoom duration:0.0];
}

- (void)createPlayer
{
    OGPlayerEntity *player = [[OGPlayerEntity alloc] initWithConfiguration:self.sceneConfiguration.playerConfiguration];
    self.player = player;
    [self addEntity:self.player];
    
    SKNode *playerInitialNode = [self childNodeWithName:kOGGameScenePlayerInitialPointNodeName];
    self.player.render.node.position = playerInitialNode.position;
}

- (void)createEnemies
{
    for (OGEnemyConfiguration *enemyConfiguration in self.sceneConfiguration.enemiesConfiguration)
    {
        OGEnemyEntity *enemy = [[OGEnemyEntity alloc] initWithConfiguration:enemyConfiguration];
        [self addEntity:enemy];
        SKNode *enemyInitialNode = [self childNodeWithName:enemyConfiguration.initialPointName];
        enemy.render.node.position = enemyInitialNode.position;
        
        enemy.physics.physicsBody.velocity = enemyConfiguration.initialVector;
    }
}

- (void)createDoors
{
    NSArray<SKNode *> *doorNodes = [self childNodeWithName:kOGGameSceneDoorsNodeName].children;
    
    for (SKNode *doorNode in doorNodes)
    {
        if ([doorNode isKindOfClass:SKSpriteNode.self])
        {
            OGDoorEntity *door = [[OGDoorEntity alloc] initWithSpriteNode:(SKSpriteNode *) doorNode];
            door.transitionDelegate = self;
            
            BOOL doorLocked = [doorNode.userData[kOGGameSceneDoorLockedKey] boolValue];
            
            door.lockComponent.target = self.player.render.node;
            door.lockComponent.openDistance = kOGGameSceneDoorOpenDistance;
            door.lockComponent.closed = YES;
            door.lockComponent.locked = doorLocked;
            
            NSString *sourceNodeName = doorNode.userData[kOGGameSceneSourceNodeName];
            NSString *destinationNodeName = doorNode.userData[kOGGameSceneDestinationNodeName];
            
            door.transition.destination = destinationNodeName ? [self childNodeWithName:destinationNodeName] : nil;
            door.transition.source = sourceNodeName ? [self childNodeWithName:sourceNodeName] : nil;
            
            for (NSString *key in doorNode.userData.allKeys)
            {
                if ([key hasPrefix:kOGGameSceneDoorKeyPrefix])
                {
                    [door addKeyName:doorNode.userData[key]];
                }
            }
            
            [self addEntity:door];
        }
    }
}

- (void)createInventoryBar
{
    self.inventoryBarNode = [OGInventoryBarNode inventoryBarNodeWithInventoryComponent:self.player.inventoryComponent];
    self.inventoryBarNode.playerEntity = self.player;
    
    if (self.camera)
    {
        [self.camera addChild:self.inventoryBarNode];
    }
    
    [self.inventoryBarNode updateConstraints];
}

- (void)createSceneItems
{
    SKNode *items = [self childNodeWithName:kOGGameSceneItemsNodeName];
    NSArray *weapons = [items childNodeWithName:kOGGameSceneWeaponNodeName].children;
    NSArray *keys = [items childNodeWithName:kOGGameSceneKeysNodeName].children;
    
    for (SKSpriteNode *weaponSprite in weapons)
    {
        OGWeaponEntity *shootingWeapon = [[OGWeaponEntity alloc] initWithSpriteNode:weaponSprite];
        shootingWeapon.delegate = self;
        [self addEntity:shootingWeapon];
    }
    
    for (SKSpriteNode *keySprite in keys)
    {
        OGKey *key = [[OGKey alloc] initWithSpriteNode:keySprite];
        [self addEntity:key];
    }
}

#pragma mark - Entity Adding

- (void)addEntity:(GKEntity *)entity
{
    [self.entities addObject:entity];
    
    for (GKComponentSystem *componentSystem in self.componentSystems)
    {
        [componentSystem addComponentWithEntity:entity];
    }
    
    SKNode *renderNode = ((OGRenderComponent *) [entity componentForClass:OGRenderComponent.self]).node;
    
    if (renderNode && !renderNode.parent)
    {
        [self addChild:renderNode];
    }
    
    OGIntelligenceComponent *intelligenceComponent = (OGIntelligenceComponent *) [entity componentForClass:OGIntelligenceComponent.self];
    
    if (intelligenceComponent)
    {
        [intelligenceComponent enterInitialState];
    }
}

- (void)removeEntity:(GKEntity *)entity
{
    SKNode *node = ((OGRenderComponent *) [entity componentForClass:OGRenderComponent.self]).node;
    
    [node removeFromParent];
    
    for (GKComponentSystem *componentSystem in self.componentSystems)
    {
        [componentSystem removeComponentWithEntity:entity];
    }
    
    [self.entities removeObject:entity];
}

#pragma mark - TransitionComponentDelegate

- (void)transitToDestinationWithTransitionComponent:(OGTransitionComponent *)component completion:(void (^)(void))completion
{
    SKNode *destinationNode = component.destination;
    
    self.currentRoom = component.destination;
    
    [self.cameraController moveCameraToNode:destinationNode duration:1.0];
    
    completion();
}

#pragma mark - Contact handling

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    [self handleContact:contact contactCallback:^(id<OGContactNotifiableType> notifiable, GKEntity *entity)
    {
        [notifiable contactWithEntityDidBegin:entity];
    }];
}

- (void)handleContact:(SKPhysicsContact *)contact contactCallback:(void (^)(id<OGContactNotifiableType>, GKEntity *))callback
{    
    SKPhysicsBody *bodyA = contact.bodyA.node.physicsBody;
    SKPhysicsBody *bodyB = contact.bodyB.node.physicsBody;
    
    GKEntity *entityA = bodyA.node.entity;
    GKEntity *entityB = bodyB.node.entity;
    
    OGColliderType *colliderTypeA = [OGColliderType existingColliderTypeWithCategoryBitMask:bodyA.categoryBitMask];
    OGColliderType *colliderTypeB = [OGColliderType existingColliderTypeWithCategoryBitMask:bodyB.categoryBitMask];
    
    BOOL aNeedsCallback = [colliderTypeA notifyOnContactWith:colliderTypeB];
    BOOL bNeedsCallback = [colliderTypeB notifyOnContactWith:colliderTypeA];
    
    if ([entityA conformsToProtocol:@protocol(OGContactNotifiableType)] && aNeedsCallback)
    {
        callback((id<OGContactNotifiableType>) entityA, entityB);
    }
    
    if ([entityB conformsToProtocol:@protocol(OGContactNotifiableType)] && bNeedsCallback)
    {
        callback((id<OGContactNotifiableType>) entityB, entityA);
    }
}

#pragma mark - Scene Management

- (void)pause
{
    self.physicsWorld.speed = kOGGameScenePauseSpeed;
    self.speed = kOGGameScenePauseSpeed;
    self.paused = YES;
}

- (void)pauseWithPauseScreen
{
    [self pause];
    
    if (!self.pauseScreenNode.parent)
    {
        [self addChild:self.pauseScreenNode];
    }
}

- (void)resume
{
    self.physicsWorld.speed = kOGGameScenePlayeSpeed;
    self.speed = kOGGameScenePlayeSpeed;
    self.paused = NO;
    
    if (self.pauseScreenNode.parent)
    {
        [self.pauseScreenNode removeFromParent];
    }
    
    if (self.gameOverScreenNode.parent)
    {
        [self.gameOverScreenNode removeFromParent];
    }
}

- (void)restart
{
    [self.sceneDelegate gameSceneDidCallRestart];
}

- (void)runStoryConclusion
{
    
}

- (void)gameOver
{
    [self pause];
    
    if (!self.gameOverScreenNode.parent)
    {
        [self addChild:self.gameOverScreenNode];
    }
}

#pragma mark - Update

- (void)update:(NSTimeInterval)currentTime
{
    [super update:currentTime];
    [self.cameraController update];
    
    CGFloat deltaTime = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    
    for (GKComponentSystem *componentSystem in self.componentSystems)
    {
        [componentSystem updateWithDeltaTime:deltaTime];
    }
    
    [self.inventoryBarNode checkPlayerPosition];
}

- (void)didFinishUpdate
{
    [super didFinishUpdate];
    
    [self.entities sortUsingComparator:(NSComparator)^(GKEntity *objA, GKEntity *objB)
    {
        OGRenderComponent *renderComponentA = (OGRenderComponent *) [objA componentForClass:OGRenderComponent.self];
        OGRenderComponent *renderComponentB = (OGRenderComponent *) [objB componentForClass:OGRenderComponent.self];
        NSComparisonResult result = NSOrderedSame;
        
        if (renderComponentA.node.position.y > renderComponentB.node.position.y)
        {
            result = NSOrderedAscending;
        }
        else
        {
            result = NSOrderedDescending;
        }
        
        return result;
    }];
    
    NSUInteger characterZPosition = kOGGameSceneZSpacePerCharacter;
    
    for (GKEntity *entity in self.entities)
    {
        OGRenderComponent *renderComponent = (OGRenderComponent *) [entity componentForClass:OGRenderComponent.self];
        renderComponent.node.zPosition = characterZPosition;
        
        characterZPosition += kOGGameSceneZSpacePerCharacter;
    }
}

@end
