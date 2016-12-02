//
//  OGGameScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

//MARK: Miscelaneous

#import "OGAudioManager.h"
#import "OGGameScene.h"
#import "OGCollisionBitMask.h"
#import "OGTouchControlInputNode.h"
#import "OGConstants.h"
#import "OGZPositionEnum.m"
#import "OGGameSceneConfiguration.h"
#import "OGEnemyConfiguration.h"
#import "OGCameraController.h"
#import "OGContactNotifiableType.h"
#import "OGLevelManager.h"
#import "OGZPositionEnum.m"
#import "OGLevelStateSnapshot.h"
#import "OGEntitySnapshot.h"

//MARK: Components

#import "OGInputComponent.h"
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
#import "OGTrailComponent.h"
#import "OGRulesComponent.h"
#import "OGShadowComponent.h"
#import "OGHealthBarComponent.h"

//MARK: Entities

#import "OGPlayerEntity.h"
#import "OGZombie.h"
#import "OGEnemyEntity.h"
#import "OGDoorEntity.h"
#import "OGShootingWeapon.h"
#import "OGKey.h"
#import "OGAidKit.h"

//MARK: Nodes

#import "OGInventoryBarNode.h"
#import "OGWeaponStatisticsNode.h"
#import "OGButtonNode.h"
#import "OGHUDNode.h"

//MARK: States

#import "OGBeforeStartLevelState.h"
#import "OGStoryConclusionLevelState.h"
#import "OGGameLevelState.h"
#import "OGPauseLevelState.h"
#import "OGCompleteLevelState.h"
#import "OGDeathLevelState.h"

//MARK: Constants

NSString *const OGGameSceneDoorsNodeName = @"doors";
NSString *const OGGameSceneItemsNodeName = @"items";
NSString *const OGGameSceneWeaponNodeName = @"weapon";
NSString *const OGGameSceneKeysNodeName = @"keys";
NSString *const OGGameSceneAidKitsNodeName = @"aid_kits";
NSString *const OGGameSceneSourceNodeName = @"source";
NSString *const OGGameSceneDestinationNodeName = @"destination";
NSString *const OGGameSceneUserDataGraphs = @"Graphs";
NSString *const OGGameSceneUserDataGraph = @"Graph_";
NSString *const OGGameSceneDoorLockedKey = @"locked";

NSString *const OGGameScenePlayerInitialPointNodeName = @"player_initial_point";

NSString *const OGGameSceneDoorKeyPrefix = @"key";

NSString *const OGGameScenePauseScreenNodeName = @"OGPauseScreen.sks";
NSString *const OGGameSceneGameOverScreenNodeName = @"OGGameOverScreen.sks";

NSString *const OGGameScenePlayerInitialPoint = @"player_initial_point";
NSString *const OGGameSceneEnemyInitialsPoints = @"enemy_initial_point";
NSString *const OGGameSceneObstacleName = @"obstacle";

NSString *const OGGameScenePauseScreenResumeButtonName = @"ResumeButton";
NSString *const OGGameScenePauseScreenRestartButtonName = @"RestartButton";
NSString *const OGGameScenePauseScreenMenuButtonName = @"MenuButton";

CGFloat const OGGameScenePauseSpeed = 0.0;
CGFloat const OGGameScenePlaySpeed = 1.0;

NSUInteger const OGGameSceneZSpacePerCharacter = 30;

@interface OGGameScene () <AVAudioPlayerDelegate>

@property (nonatomic, strong) SKNode *currentRoom;
@property (nonatomic, strong) OGCameraController *cameraController;
@property (nonatomic, weak) OGPlayerEntity *player;
@property (nonatomic, strong) OGGameSceneConfiguration *sceneConfiguration;

@property (nonatomic, strong) SKReferenceNode *pauseScreenNode;
@property (nonatomic, strong) SKReferenceNode *gameOverScreenNode;

@property (nonatomic, strong) OGHUDNode *hudNode;
@property (nonatomic, strong) OGInventoryBarNode *inventoryBarNode;
@property (nonatomic, strong) OGWeaponStatisticsNode *weaponStatisticsNode;
@property (nonatomic, strong) OGTouchControlInputNode *controllInputNode;

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
                             [[GKComponentSystem alloc] initWithComponentClass:[OGHealthBarComponent class]],
                             nil];
        
        _pauseScreenNode = [[SKReferenceNode alloc] initWithFileNamed:OGGameScenePauseScreenNodeName];
        _pauseScreenNode.zPosition = OGZPositionCategoryForeground;
        
        _gameOverScreenNode = [[SKReferenceNode alloc] initWithFileNamed:OGGameSceneGameOverScreenNodeName];
        _gameOverScreenNode.zPosition = OGZPositionCategoryForeground;
    }
    
    return self;
}

#pragma mark - Scene contents

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.physicsWorld.contactDelegate = self;
    
    [self.obstaclesGraph addObstacles:self.polygonObstacles];
    
    self.currentRoom = [self childNodeWithName:self.sceneConfiguration.startRoom];
    [self createSceneContents];
    
    [self createCameraNode];
    [self createTouchControlInputNode];
    
    [self.stateMachine enterState:[OGGameLevelState class]];
    
    [self.audioManager playMusic:self.sceneConfiguration.backgroundMusic];
    self.audioManager.musicPlayerDelegate = self;
    
    [self.cameraController moveCameraToNode:self.currentRoom];
    
    [self createHUD];
}

#pragma mark - Scene Contents Creation

- (void)createSceneContents
{
    [self createPlayer];
    [self createEnemies];
    [self createDoors];
    [self createSceneItems];
}

- (void)createTouchControlInputNode
{
    OGTouchControlInputNode *inputNode = [[OGTouchControlInputNode alloc] initWithFrame:self.frame thumbStickNodeSize:[OGConstants thumbStickNodeSize]];
    inputNode.size = self.size;
    self.controllInputNode = inputNode;
    self.controllInputNode.zPosition = OGZPositionCategoryTouchControl;
    
    OGInputComponent *inputComponent = (OGInputComponent *) [self.player componentForClass:[OGInputComponent class]];
    inputNode.inputSourceDelegate = (id<OGControlInputSourceDelegate>) inputComponent;
    inputNode.position = CGPointZero;
    [self.camera addChild:inputNode];
}

- (void)createCameraNode
{
    SKCameraNode *camera = [[SKCameraNode alloc] init];
    self.camera = camera;
    self.camera.zPosition = OGZPositionCategoryForeground;
    self.cameraController.camera = camera;
    [self addChild:camera];
    
    self.cameraController.target = self.player.renderComponent.node;
}

- (void)createPlayer
{
    OGPlayerEntity *player = [[OGPlayerEntity alloc] initWithConfiguration:self.sceneConfiguration.playerConfiguration];
    player.delegate = self;
    self.player = player;
    
    [self addEntity:self.player];
    
    self.listener = self.player.renderComponent.node;
    
    SKNode *playerInitialNode = [self childNodeWithName:OGGameScenePlayerInitialPointNodeName];
    self.player.renderComponent.node.position = playerInitialNode.position;
}

- (void)createEnemies
{
    NSUInteger counter = 0;
    
    for (OGEnemyConfiguration *enemyConfiguration in self.sceneConfiguration.enemiesConfiguration)
    {
        NSString *graphName = [NSString stringWithFormat:@"%@%lu", OGGameSceneUserDataGraph, (unsigned long) counter];
        GKGraph *graph = self.userData[OGGameSceneUserDataGraphs][graphName];
        
        OGEnemyEntity *enemy = [[enemyConfiguration.enemyClass alloc] initWithConfiguration:enemyConfiguration graph:graph];
        enemy.delegate = self;
        
        if ([enemy isMemberOfClass:[OGZombie class]])
        {
            OGTrailComponent *trailComponent = (OGTrailComponent *) [enemy componentForClass:[OGTrailComponent class]];
            trailComponent.targetNode = self;
        }
        
        [self addEntity:enemy];
        
        counter++;
    }
}

- (void)createDoors
{
    NSArray<SKNode *> *doorNodes = [self childNodeWithName:OGGameSceneDoorsNodeName].children;
    
    for (SKNode *doorNode in doorNodes)
    {
        if ([doorNode isKindOfClass:[SKSpriteNode class]])
        {
            OGDoorConfiguration *doorConfiguration = (OGDoorConfiguration *) [self.sceneConfiguration findConfigurationWithUnitName:doorNode.name];
            OGDoorEntity *door = [[OGDoorEntity alloc] initWithSpriteNode:(SKSpriteNode *) doorNode configuration:doorConfiguration];
            
            OGLockComponent *lockComponent = (OGLockComponent *) [door componentForClass:[OGLockComponent class]];
            
            door.transitionDelegate = self;
            lockComponent.target = self.player.renderComponent.node;
            
            [self addEntity:door];
        }
    }
}

- (void)createSceneItems
{
    SKNode *items = [self childNodeWithName:OGGameSceneItemsNodeName];
    NSArray *weapons = [items childNodeWithName:OGGameSceneWeaponNodeName].children;
    NSArray *keys = [items childNodeWithName:OGGameSceneKeysNodeName].children;
    NSArray *aidKits = [items childNodeWithName:OGGameSceneAidKitsNodeName].children;
    
    for (SKSpriteNode *weaponSprite in weapons)
    {
        OGWeaponConfiguration *weaponConfiguration = (OGWeaponConfiguration *) [self.sceneConfiguration findConfigurationWithUnitName:weaponSprite.name];
        OGShootingWeapon *shootingWeapon = [[OGShootingWeapon alloc] initWithSpriteNode:weaponSprite
                                                                          configuration:weaponConfiguration];
        shootingWeapon.delegate = self;
        [self addEntity:shootingWeapon];
    }
    
    for (SKSpriteNode *keySprite in keys)
    {
        OGKey *key = [[OGKey alloc] initWithSpriteNode:keySprite];
        [self addEntity:key];
    }
    
    for (SKSpriteNode *aidKitSprite in aidKits)
    {
        OGAidKit *aidKit = [[OGAidKit alloc] initWithSpriteNode:aidKitSprite];
        aidKit.delegate = self;
        aidKit.healthComponentDelegate = (id<OGHealthComponentDelegate>) self.player;
        [self addEntity:aidKit];
    }
}

#pragma mark HUD creation

- (void)createHUD
{
    self.hudNode = [OGHUDNode node];
    self.hudNode.size = self.size;
    
    if (self.camera)
    {
        [self.camera addChild:self.hudNode];
    }
    
    [self createInventoryBar];
    [self createWeaponStatistics];
}

- (void)createWeaponStatistics
{
    self.weaponStatisticsNode = [[OGWeaponStatisticsNode alloc] init];
    
    if (self.weaponStatisticsNode)
    {
        OGWeaponComponent *weaponComponent = (OGWeaponComponent *) [self.player componentForClass:[OGWeaponComponent class]];
        weaponComponent.weaponObserver = self.weaponStatisticsNode;
        [self.hudNode addHUDElement:self.weaponStatisticsNode];
    }
}

- (void)createInventoryBar
{
    OGInventoryComponent *inventoryComponent = (OGInventoryComponent *) [self.player componentForClass:[OGInventoryComponent class]];
    self.inventoryBarNode = [OGInventoryBarNode inventoryBarNodeWithInventoryComponent:inventoryComponent screenSize:self.camera.calculateAccumulatedFrame.size];
    
    if (self.hudNode)
    {
        [self.hudNode addHUDElement:self.inventoryBarNode];
    }
    
    [self.inventoryBarNode updateConstraints];
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
        
        SKNode *shadowNode = ((OGShadowComponent *) [entity componentForClass:[OGShadowComponent class]]).node;
        
        if (shadowNode)
        {
            shadowNode.zPosition = OGZPositionCategoryShadows;
        }
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

- (void)playerDidDie
{
    [self gameOver];
}

#pragma mark - TransitionComponentDelegate

- (void)transitToDestinationWithTransitionComponent:(OGTransitionComponent *)component completion:(void (^)(void))completion
{
    self.currentRoom = component.destination;
    
    [self.cameraController moveCameraToNode:self.currentRoom];
    
    completion();
}

#pragma mark - Audio Player Delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag)
    {
        [player play];
    }
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
    self.physicsWorld.speed = OGGameScenePauseSpeed;
    self.speed = OGGameScenePauseSpeed;
    
    self.pausedTimeInterval = NSTimeIntervalSince1970;
    self.controllInputNode.shouldHideThumbStickNodes = YES;
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
    
    self.controllInputNode.shouldHideThumbStickNodes = NO;
    
    self.physicsWorld.speed = OGGameScenePlaySpeed;
    self.speed = OGGameScenePlaySpeed;
    
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

- (void)runStoryConclusion
{
    
}

- (void)gameOver
{
    [self pauseWithoutPauseScreen];
    
    if (!self.gameOverScreenNode.parent)
    {
        [self addChild:self.gameOverScreenNode];
    }
}

#pragma mark - Snapshot

- (OGEntitySnapshot *)entitySnapshotWithEntity:(GKEntity *)entity
{
    if (!self.levelSnapshot)
    {
        self.levelSnapshot = [[OGLevelStateSnapshot alloc] initWithScene:self];
    }
    
    NSUInteger index = [self.levelSnapshot.snapshot[OGLevelStateSnapshotEntitiesKey] indexOfObject:entity];
    
    return [self.levelSnapshot.snapshot[OGLevelStateSnapshotSnapshotsKey] objectAtIndex:index];
}

#pragma mark - Update

- (void)update:(NSTimeInterval)currentTime
{
    [super update:currentTime];
    
    if (self.lastUpdateTimeInterval == 0)
    {
        self.lastUpdateTimeInterval = currentTime;
    }
    
    if (!self.customPaused)
    {
        self.levelSnapshot = nil;
        
        CGFloat deltaTime = currentTime - self.lastUpdateTimeInterval;
        self.lastUpdateTimeInterval = currentTime;
        
        NSArray *array = [NSArray arrayWithArray:self.componentSystems];
        for (GKComponentSystem *componentSystem in array)
        {
            [componentSystem updateWithDeltaTime:deltaTime];
        }
        
        [self.inventoryBarNode checkPlayerPosition];
    }
    
    [self.hudNode updateHUD];
}

- (void)didFinishUpdate
{    
    [super didFinishUpdate];
    
    if (((OGRenderComponent *) [self.player componentForClass:[OGRenderComponent class]]).node)
    {
        [self.player updateAgentPositionToMatchNodePosition];
    }
    
    [self sortSpritesWithZPosition];
}

- (void)sortSpritesWithZPosition
{
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
        characterZPosition += OGGameSceneZSpacePerCharacter;
    }        
}

#pragma mark - Getters

- (NSArray<SKSpriteNode *> *)obstacleSpriteNodes
{
    NSMutableArray<SKSpriteNode *> *result = nil;
    
    [self enumerateChildNodesWithName:OGGameSceneObstacleName usingBlock:^(SKNode * node, BOOL * stop)
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

- (GKObstacleGraph *)obstaclesGraph
{
    if (!_obstaclesGraph)
    {
        _obstaclesGraph = [[GKObstacleGraph alloc] initWithObstacles:[[NSArray alloc] init]
                                                        bufferRadius:OGEnemyEntityPathfindingGraphBufferRadius];
    }
    
    return _obstaclesGraph;
}

#pragma mark - Button Click Handling

- (void)onButtonClick:(OGButtonNode *)buttonNode
{
    if ([buttonNode.name isEqualToString:OGGameScenePauseScreenResumeButtonName])
    {
        [self.sceneDelegate didCallResume];
    }
    else if ([buttonNode.name isEqualToString:OGGameScenePauseScreenRestartButtonName])
    {
        [self.sceneDelegate didCallRestart];
    }
    else if ([buttonNode.name isEqualToString:OGGameScenePauseScreenMenuButtonName])
    {
        [self.sceneDelegate didCallExit];
    }
}

@end
