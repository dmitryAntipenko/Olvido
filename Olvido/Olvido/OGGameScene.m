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
#import "OGEnemyEntity.h"
#import "OGDoorEntity.h"
#import "OGWeaponEntity.h"
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

#import "OGStatusBar.h"
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

NSString *const kOGGameSceneStatusBarSpriteName = @"StatusBar";

NSString *const kOGGameScenePauseScreenNodeName = @"OGPauseScreen.sks";
NSString *const kOGGameSceneGameOverScreenNodeName = @"OGGameOverScreen.sks";

CGFloat const kOGGameScenePauseSpeed = 0.0;
CGFloat const kOGGameScenePlayeSpeed = 1.0;

CGFloat const kOGGameSceneDoorOpenDistance = 100.0;

@interface OGGameScene ()

@property (nonatomic, strong) SKNode *currentRoom;
@property (nonatomic, strong) OGCameraController *cameraController;

@property (nonatomic, strong) OGGameSceneConfiguration *sceneConfiguration;
@property (nonatomic, strong) GKStateMachine *stateMachine;
@property (nonatomic, strong) SKReferenceNode *pauseScreenNode;
@property (nonatomic, strong) SKReferenceNode *gameOverScreenNode;
@property (nonatomic, strong) OGInventoryBarNode *inventoryBarNode;

@property (nonatomic, assign) CGFloat lastUpdateTimeInterval;

@property (nonatomic, strong) NSMutableSet<GKEntity *> *entities;
@property (nonatomic, strong) NSMutableArray<GKComponentSystem *> *componentSystems;

@end

@implementation OGGameScene

@synthesize name = _name;
@synthesize graphs = _graphs;

#pragma mark - Initializer

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        _inventoryBarNode = [OGInventoryBarNode node];
        
        _sceneConfiguration = [OGGameSceneConfiguration gameSceneConfigurationWithFileName:_name];
        
        _cameraController = [[OGCameraController alloc] init];
        
        _player = [[OGPlayerEntity alloc] init];
        
        _stateMachine = [[GKStateMachine alloc] initWithStates:@[
                                                                 [OGStoryConclusionLevelState stateWithLevelScene:self],
                                                                 [OGBeforeStartLevelState stateWithLevelScene:self],
                                                                 [OGGameLevelState stateWithLevelScene:self],
                                                                 [OGPauseLevelState stateWithLevelScene:self],
                                                                 [OGCompleteLevelState stateWithLevelScene:self],
                                                                 [OGDeathLevelState stateWithLevelScene:self]
                                                                 ]];
        
        _entities = [[NSMutableSet alloc] init];
        
        _componentSystems = [[NSMutableArray alloc] initWithObjects:
                             [[GKComponentSystem alloc] initWithComponentClass:OGAnimationComponent.self],
                             [[GKComponentSystem alloc] initWithComponentClass:OGMovementComponent.self],
                             [[GKComponentSystem alloc] initWithComponentClass:OGIntelligenceComponent.self],
                             [[GKComponentSystem alloc] initWithComponentClass:OGLockComponent.self],
                             [[GKComponentSystem alloc] initWithComponentClass:OGMessageComponent.self],
                             [[GKComponentSystem alloc] initWithComponentClass:OGWeaponComponent.self],
                             nil];
        
        _statusBar = [[OGStatusBar alloc] init];
        
        _pauseScreenNode = [[SKReferenceNode alloc] initWithFileNamed:kOGGameScenePauseScreenNodeName];
        _gameOverScreenNode = [[SKReferenceNode alloc] initWithFileNamed:kOGGameSceneGameOverScreenNodeName];
    }
    
    return self;
}

#pragma mark - Scene contents

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.currentRoom = [self childNodeWithName:@"room1"];
    
    self.physicsWorld.contactDelegate = self;
    self.lastUpdateTimeInterval = 0.0;
    
    [self createSceneContents];

    [self addEntity:self.player];

    [self createCameraNode];
    [self createStatusBar];
    [self createInventoryBar];
    
    OGTouchControlInputNode *inputNode = [[OGTouchControlInputNode alloc] initWithFrame:self.frame thumbStickNodeSize:CGSizeMake(200.0, 200.0)];
    inputNode.size = self.size;
    inputNode.inputSourceDelegate = (id<OGControlInputSourceDelegate>) self.player.input;
    inputNode.position = CGPointZero;
    [self.camera addChild:inputNode];
    
    [self.stateMachine enterState:[OGGameLevelState class]];
}

- (void)createCameraNode
{
    SKCameraNode *camera = [[SKCameraNode alloc] init];
    self.camera = camera;
    self.cameraController.camera = camera;
    [self addChild:camera];
    
    self.cameraController.target = self.player.render.node;
    
    [self.cameraController moveCameraToNode:self.currentRoom];
}

- (void)createSceneContents
{
    [self addEntity:self.player];
    SKNode *playerInitialNode = [self childNodeWithName:@"player_initial_point"];
    self.player.render.node.position = playerInitialNode.position;
    
    for (OGEnemyConfiguration *enemyConfiguration in self.sceneConfiguration.enemiesConfiguration)
    {
        OGEnemyEntity *enemy = [[OGEnemyEntity alloc] init];
        [self addEntity:enemy];
        SKNode *enemyInitialNode = [self childNodeWithName:enemyConfiguration.initialPointName];
        enemy.render.node.position = enemyInitialNode.position;
        
        enemy.physics.physicsBody.velocity = enemyConfiguration.initialVector;
    }
    
    NSArray<SKNode *> *doorNodes = [self childNodeWithName:@"doors"].children;
    
    for (SKNode *doorNode in doorNodes)
    {
        if ([doorNode isKindOfClass:SKSpriteNode.self])
        {
            OGDoorEntity *door = [[OGDoorEntity alloc] initWithSpriteNode:(SKSpriteNode *) doorNode];
            door.transitionDelegate = self;
            
            door.lockComponent.target = self.player.render.node;
            door.lockComponent.openDistance = kOGGameSceneDoorOpenDistance;
            door.lockComponent.closed = YES;
            door.lockComponent.locked = NO;
            
            NSString *sourceNodeName = doorNode.userData[@"source"];
            NSString *destinationNodeName = doorNode.userData[@"destination"];
            
            door.transition.destination = destinationNodeName ? [self childNodeWithName:destinationNodeName] : nil;
            door.transition.source = sourceNodeName ? [self childNodeWithName:sourceNodeName] : nil;
            
            [self addEntity:door];
        }
    }
    
    [self createSceneItems];
}

- (void)createInventoryBar
{
    self.inventoryBarNode = [OGInventoryBarNode inventoryBarNodeWithInventoryComponent:self.player.inventoryComponent];
    
    if (self.camera)
    {
        [self.camera addChild:self.inventoryBarNode];
    }
    
    [self.inventoryBarNode update];
}

- (void)createSceneItems
{
    SKNode *items = [self childNodeWithName:@"items"];
    NSArray *weapons = [items childNodeWithName:@"weapon"].children;
    
    for (SKSpriteNode *weapon in weapons)
    {
        OGWeaponEntity *shootingWeapon = [[OGWeaponEntity alloc] initWithSpriteNode:weapon];
        [self addEntity:shootingWeapon];
    }
}

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

- (void)createStatusBar
{
    SKSpriteNode *statusBar = (SKSpriteNode *) [self childNodeWithName:kOGGameSceneStatusBarSpriteName];
    
    if (statusBar)
    {
        self.statusBar.statusBarSprite = statusBar;
        self.statusBar.healthComponent = self.player.health;
        [self.statusBar createContents];
    }
}

#pragma mark - TransitionComponentDelegate

- (void)transitToDestinationWithTransitionComponent:(OGTransitionComponent *)component completion:(void (^)(void))completion
{
    SKNode *destinationNode = component.destination;
    
    self.currentRoom = component.destination;
    
    [self.cameraController moveCameraToNode:destinationNode];
    
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

- (void)didEndContact:(SKPhysicsContact *)contact
{
    [self handleContact:contact contactCallback:^(id<OGContactNotifiableType> notifiable, GKEntity *entity)
     {
         [notifiable contactWithEntityDidEnd:entity];
     }];
}

- (void)handleContact:(SKPhysicsContact *)contact contactCallback:(void (^)(id<OGContactNotifiableType>, GKEntity *))callback
{
    SKPhysicsBody *bodyA = contact.bodyA.node.physicsBody;
    SKPhysicsBody *bodyB = contact.bodyB.node.physicsBody;
    
    GKEntity *entityA = bodyA.node.entity;
    GKEntity *entityB = bodyB.node.entity;
    
    OGColliderType *colliderTypeA = [OGColliderType colliderTypeWithCategoryBitMask:bodyA.categoryBitMask];
    OGColliderType *colliderTypeB = [OGColliderType colliderTypeWithCategoryBitMask:bodyB.categoryBitMask];
    
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

- (void)onMenuButtonClick
{
//    NSString *sceneFilePath = nil;
//    
//    sceneFilePath = [[NSBundle mainBundle] pathForResource:kOGMapMenuSceneFileName ofType:kOGSceneFileExtension];
//    
//    if (sceneFilePath)
//    {
//        SKScene *nextScene = [NSKeyedUnarchiver unarchiveObjectWithFile:sceneFilePath];
//        
//        if (nextScene)
//        {
//            [self.view presentScene:nextScene];
//        }
//    }
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
}

#pragma mark - Setters

-(void)setGraphs:(NSDictionary<NSString *,GKGraph *> *)graphs
{
    _graphs = [graphs copy];
}

@end
