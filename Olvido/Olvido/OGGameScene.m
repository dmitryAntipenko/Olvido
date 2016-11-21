//
//  OGGameScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTrailComponent.h"

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
#import "OGButtonNode.h"

#import "OGBeforeStartLevelState.h"
#import "OGStoryConclusionLevelState.h"
#import "OGGameLevelState.h"
#import "OGPauseLevelState.h"
#import "OGCompleteLevelState.h"
#import "OGDeathLevelState.h"

#import "OGLevelManager.h"
#import "OGAnimationComponent.h"
#import "OGAnimationState.h"
#import "OGZPositionEnum.m"

#import "OGEntitySnapshot.h"
#import "OGLevelStateSnapshot.h"

#import "OGRulesComponent.h"

NSString *const kOGGameSceneDoorsNodeName = @"doors";
NSString *const kOGGameSceneItemsNodeName = @"items";
NSString *const kOGGameSceneWeaponNodeName = @"weapon";
NSString *const kOGGameSceneKeysNodeName = @"keys";
NSString *const kOGGameSceneSourceNodeName = @"source";
NSString *const kOGGameSceneDestinationNodeName = @"destination";
NSString *const kOGGameSceneUserDataGraphs = @"Graphs";
NSString *const kOGGameSceneUserDataGraph = @"Graph_";
NSString *const kOGGameSceneDoorLockedKey = @"locked";

NSString *const kOGGameScenePlayerInitialPointNodeName = @"player_initial_point";

NSString *const kOGGameSceneDoorKeyPrefix = @"key";

NSString *const kOGGameScenePauseScreenNodeName = @"OGPauseScreen.sks";
NSString *const kOGGameSceneGameOverScreenNodeName = @"OGGameOverScreen.sks";

NSString *const kOGGameScenePlayerInitialPoint = @"player_initial_point";
NSString *const kOGGameSceneEnemyInitialsPoints = @"enemy_initial_point";
NSString *const kOGGameSceneObstacleName = @"obstacle";

NSString *const kOGGameScenePauseScreenResumeButtonName = @"ResumeButton";
NSString *const kOGGameScenePauseScreenRestartButtonName = @"RestartButton";
NSString *const kOGGameScenePauseScreenMenuButtonName = @"MenuButton";

CGFloat const kOGGameScenePauseSpeed = 0.0;
CGFloat const kOGGameScenePlayeSpeed = 1.0;

CGFloat const kOGGameSceneDoorOpenDistance = 50.0;

NSUInteger const kOGGameSceneZSpacePerCharacter = 100;

@interface OGGameScene ()

@property (nonatomic, strong) SKNode *currentRoom;
@property (nonatomic, strong) OGCameraController *cameraController;
@property (nonatomic, strong) OGPlayerEntity *player;
@property (nonatomic, strong) OGGameSceneConfiguration *sceneConfiguration;
@property (nonatomic, strong) SKReferenceNode *pauseScreenNode;
@property (nonatomic, strong) SKReferenceNode *gameOverScreenNode;
@property (nonatomic, strong) OGInventoryBarNode *inventoryBarNode;

@property (nonatomic, assign) CGFloat lastUpdateTimeInterval;
@property (nonatomic, assign) NSTimeInterval pausedTimeInterval;

@property (nonatomic, strong) NSMutableOrderedSet<GKEntity *> *mutableEntities;

@property (nonatomic, strong) NSMutableArray<GKComponentSystem *> *componentSystems;

@property (nonatomic, strong) OGLevelStateSnapshot *levelSnapshot;


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
        
        _mutableEntities = [[NSMutableOrderedSet alloc] init];
        
        _componentSystems = [[NSMutableArray alloc] initWithObjects:
                             [[GKComponentSystem alloc] initWithComponentClass:[GKAgent2D class]],
                             [[GKComponentSystem alloc] initWithComponentClass:[OGAnimationComponent class]],
                             [[GKComponentSystem alloc] initWithComponentClass:[OGMovementComponent class]],
                             [[GKComponentSystem alloc] initWithComponentClass:[OGIntelligenceComponent class]],
                             [[GKComponentSystem alloc] initWithComponentClass:[OGLockComponent class]],
                             [[GKComponentSystem alloc] initWithComponentClass:[OGMessageComponent class]],
                             [[GKComponentSystem alloc] initWithComponentClass:[OGWeaponComponent class]],
                             [[GKComponentSystem alloc] initWithComponentClass:[OGTrailComponent class]],
                             [[GKComponentSystem alloc] initWithComponentClass:[OGRulesComponent class]],
                             nil];
        
        _pauseScreenNode = [[SKReferenceNode alloc] initWithFileNamed:kOGGameScenePauseScreenNodeName];
        _pauseScreenNode.zPosition = OGZPositionCategoryForeground;
        
        _gameOverScreenNode = [[SKReferenceNode alloc] initWithFileNamed:kOGGameSceneGameOverScreenNodeName];
        _gameOverScreenNode.zPosition = OGZPositionCategoryForeground;
    }
    
    return self;
}

#pragma mark - Scene contents

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.physicsWorld.contactDelegate = self;
    self.lastUpdateTimeInterval = 0.0;
    
    [self.obstaclesGraph addObstacles:self.polygonObstacles];
    
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
    self.camera.zPosition = OGZPositionCategoryForeground;
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
    NSUInteger counter = 0;
    
    for (OGEnemyConfiguration *enemyConfiguration in self.sceneConfiguration.enemiesConfiguration)
    {
        NSString *graphName = [NSString stringWithFormat:@"%@%lu", kOGGameSceneUserDataGraph, (unsigned long)counter];
        GKGraph *graph = self.userData[kOGGameSceneUserDataGraphs][graphName];
        
        OGEnemyEntity *enemy = [[OGEnemyEntity alloc] initWithConfiguration:enemyConfiguration
                                                                      graph:graph];
        
        enemy.trailComponent.targetNode = self;
        
        [self addEntity:enemy];
        
        counter++;
    }
}

- (void)createDoors
{
    NSArray<SKNode *> *doorNodes = [self childNodeWithName:kOGGameSceneDoorsNodeName].children;
    
    for (SKNode *doorNode in doorNodes)
    {
        if ([doorNode isKindOfClass:[SKSpriteNode class]])
        {
            OGDoorEntity *door = [[OGDoorEntity alloc] initWithSpriteNode:(SKSpriteNode *) doorNode];
            door.transitionDelegate = self;
            
            BOOL doorLocked = [doorNode.userData[kOGGameSceneDoorLockedKey] boolValue];
            
            door.lockComponent.target = self.player.render.node;
            door.lockComponent.openDistance = kOGGameSceneDoorOpenDistance;
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
    [self.mutableEntities addObject:entity];
    
    for (GKComponentSystem *componentSystem in self.componentSystems)
    {
        [componentSystem addComponentWithEntity:entity];
    }
    
    SKNode *renderNode = ((OGRenderComponent *) [entity componentForClass:[OGRenderComponent class]]).node;
    
    if (renderNode && !renderNode.parent)
    {
        [self addChild:renderNode];
    }
    
    OGIntelligenceComponent *intelligenceComponent = (OGIntelligenceComponent *) [entity componentForClass:[OGIntelligenceComponent class]];
    
    if (intelligenceComponent)
    {
        [intelligenceComponent enterInitialState];
    }
}

- (void)removeEntity:(GKEntity *)entity
{
    SKNode *node = ((OGRenderComponent *) [entity componentForClass:[OGRenderComponent class]]).node;
    
    [node removeFromParent];
    
    for (GKComponentSystem *componentSystem in self.componentSystems)
    {
        [componentSystem removeComponentWithEntity:entity];
    }
    
    [self.mutableEntities removeObject:entity];
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
    [super pause];
    
    [self pauseWithoutPauseScreen];
    [self showPauseScreen];
}

- (void)pauseWithoutPauseScreen
{
    self.physicsWorld.speed = kOGGameScenePauseSpeed;
    self.speed = kOGGameScenePauseSpeed;
    
    self.pausedTimeInterval = NSTimeIntervalSince1970;
}

- (void)showPauseScreen
{
    if (!self.pauseScreenNode.parent)
    {
        [self.camera addChild:self.pauseScreenNode];
    }
}

- (void)resume
{
    [super resume];
    
    self.physicsWorld.speed = kOGGameScenePlayeSpeed;
    self.speed = kOGGameScenePlayeSpeed;
    
    if (self.pauseScreenNode.parent)
    {
        [self.pauseScreenNode removeFromParent];
    }
    
    if (self.gameOverScreenNode.parent)
    {
        [self.gameOverScreenNode removeFromParent];
    }
    
    if (self.pausedTimeInterval != 0.0)
    {
        self.lastUpdateTimeInterval = NSTimeIntervalSince1970 - self.pausedTimeInterval;
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

#pragma mark - Snapshot

- (OGEntitySnapshot *)entitySnapshotWithEntity:(GKEntity *)entity
{
    if (self.levelSnapshot == nil)
    {
        self.levelSnapshot = [[OGLevelStateSnapshot alloc] initWithScene:self];
    }
    
    NSUInteger index = [self.levelSnapshot.snapshot[kOGLevelStateSnapshotEntitiesKey] indexOfObject:entity];
    
    return [self.levelSnapshot.snapshot[kOGLevelStateSnapshotSnapshotsKey] objectAtIndex:index];
}

#pragma mark - Update

- (void)update:(NSTimeInterval)currentTime
{
    [super update:currentTime];
    [self.cameraController update];
    
    if (self.lastUpdateTimeInterval == 0)
    {
        self.lastUpdateTimeInterval = currentTime;
    }
    
    if (!self.customPaused)
    {
        self.levelSnapshot = nil;
        
        CGFloat deltaTime = currentTime - self.lastUpdateTimeInterval;
        self.lastUpdateTimeInterval = currentTime;
        
        for (GKComponentSystem *componentSystem in self.componentSystems)
        {
            [componentSystem updateWithDeltaTime:deltaTime];
        }
        
        [self.inventoryBarNode checkPlayerPosition];
    }
}

- (void)didFinishUpdate
{
    [super didFinishUpdate];
    
    if (((OGRenderComponent *) [self.player componentForClass:[OGRenderComponent class]]).node)
    {
        [self.player updateAgentPositionToMatchNodePosition];
    }
    
    [self.mutableEntities sortUsingComparator:(NSComparator)^(GKEntity *objA, GKEntity *objB)
     {
         OGRenderComponent *renderComponentA = (OGRenderComponent *) [objA componentForClass:[OGRenderComponent class]];
         OGRenderComponent *renderComponentB = (OGRenderComponent *) [objB componentForClass:[OGRenderComponent class]];
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
    
    NSUInteger characterZPosition = OGZPositionCategoryPhysicsWorld;
    
    for (GKEntity *entity in self.entities)
    {
        OGRenderComponent *renderComponent = (OGRenderComponent *) [entity componentForClass:[OGRenderComponent class]];
        renderComponent.node.zPosition = characterZPosition;
        
        characterZPosition += kOGGameSceneZSpacePerCharacter;
        
        
    }
}

- (NSArray<SKSpriteNode *> *)obstacleSpriteNodes
{
    NSMutableArray<SKSpriteNode *> *result = nil;
    
    [self enumerateChildNodesWithName:kOGGameSceneObstacleName usingBlock:^(SKNode * node, BOOL * stop)
     {
         [result addObject:(SKSpriteNode *)node];
     }];
    
    return result;
}

- (NSArray<GKPolygonObstacle *> *)polygonObstacles
{
    return [SKNode obstaclesFromNodePhysicsBodies:self.obstacleSpriteNodes];;
}

- (NSArray<GKEntity *> *)entities
{
    return self.mutableEntities.array;
}

- (void)onButtonClick:(OGButtonNode *)buttonNode
{
    if ([buttonNode.name isEqualToString:kOGGameScenePauseScreenResumeButtonName])
    {
        [self.sceneDelegate resume];
    }
    else if ([buttonNode.name isEqualToString:kOGGameScenePauseScreenRestartButtonName])
    {
        [self.sceneDelegate restart];
    }
    else if ([buttonNode.name isEqualToString:kOGGameScenePauseScreenMenuButtonName])
    {
        [self.sceneDelegate exitToMenu];
    }
}

- (GKObstacleGraph *)obstaclesGraph
{
    if (!_obstaclesGraph)
    {
        _obstaclesGraph = [[GKObstacleGraph alloc] initWithObstacles:[[NSArray alloc] init]
                                                        bufferRadius:kOGEnemyEntityPathfindingGraphBufferRadius];
    }
    
    return _obstaclesGraph;
}

@end
