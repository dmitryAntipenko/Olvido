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
#import "OGRenderComponent.h"
#import "OGLockComponent.h"
#import "OGPhysicsComponent.h"
#import "OGMovementComponent.h"
#import "OGIntelligenceComponent.h"
#import "OGAnimationComponent.h"
#import "OGMessageComponent.h"

#import "OGStatusBar.h"

#import "OGBeforeStartLevelState.h"
#import "OGStoryConclusionLevelState.h"
#import "OGGameLevelState.h"
#import "OGPauseLevelState.h"
#import "OGCompleteLevelState.h"
#import "OGDeathLevelState.h"

#import "OGLevelManager.h"
#import "OGTapMovementControlComponent.h"
#import "OGTapAndStopMovementControlComponent.h"
#import "OGDragMovementControlComponent.h"
#import "OGAnimationComponent.h"
#import "OGAnimationState.h"

NSString *const kOGGameSceneStatusBarSpriteName = @"StatusBar";

NSString *const kOGGameScenePauseScreenNodeName = @"OGPauseScreen.sks";
NSString *const kOGGameSceneGameOverScreenNodeName = @"OGGameOverScreen.sks";

CGFloat const kOGGameScenePauseSpeed = 0.0;
CGFloat const kOGGameScenePlayeSpeed = 1.0;

@interface OGGameScene ()

@property (nonatomic, strong) SKNode *currentRoom;
@property (nonatomic, strong) OGCameraController *cameraController;

@property (nonatomic, strong) OGGameSceneConfiguration *sceneConfiguration;
@property (nonatomic, strong) GKStateMachine *stateMachine;
@property (nonatomic, strong) SKReferenceNode *pauseScreenNode;
@property (nonatomic, strong) SKReferenceNode *gameOverScreenNode;

@property (nonatomic, assign) CGFloat lastUpdateTimeInterval;

@property (nonatomic, strong) NSMutableSet<GKEntity *> *entities;
@property (nonatomic, strong) NSMutableArray<GKComponentSystem *> *componentSystems;

@end

@implementation OGGameScene

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        _sceneConfiguration = [[OGGameSceneConfiguration alloc] init];
        _cameraController = [[OGCameraController alloc] init];
        _player = [[OGPlayerEntity alloc] init];

        [OGPlayerEntity loadResourcesWithCompletionHandler:^{
            NSLog(@"Success! Animation loaded!");
            _player = [[OGPlayerEntity alloc] init];
        }];


        _sceneConfiguration = [[OGGameSceneConfiguration alloc] init];
        _cameraController = [[OGCameraController alloc] init];

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
<<<<<<< HEAD
=======
                             [[GKComponentSystem alloc] initWithComponentClass:OGLockComponent.self],
>>>>>>> vicrattlehead_sandbox
                             [[GKComponentSystem alloc] initWithComponentClass:OGMessageComponent.self],
                             nil];
        
        _statusBar = [[OGStatusBar alloc] init];
        
        _pauseScreenNode = [[SKReferenceNode alloc] initWithFileNamed:kOGGameScenePauseScreenNodeName];
        _gameOverScreenNode = [[SKReferenceNode alloc] initWithFileNamed:kOGGameSceneGameOverScreenNodeName];
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.currentRoom = [self childNodeWithName:@"room1"];
    
    self.physicsWorld.contactDelegate = self;
    self.lastUpdateTimeInterval = 0.0;
    [self.sceneConfiguration loadConfigurationWithFileName:self.name];
    
    [self createSceneContents];
    
    SKCameraNode *camera = [[SKCameraNode alloc] init];
    self.camera = camera;
    self.cameraController.camera = camera;
    [self addChild:camera];

    
    [self addEntity:self.player];
    
    SKNode *playerInitialNode = [self childNodeWithName:@"player_initial_position"];
    self.player.render.node.position = playerInitialNode.position;
    
    [self createStatusBar];
    self.cameraController.target = self.player.render.node;
    
    [self.cameraController moveCameraToNode:self.currentRoom];

    OGTouchControlInputNode *inputNode = [[OGTouchControlInputNode alloc] initWithFrame:self.frame thumbStickNodeSize:CGSizeMake(200.0, 200.0)];
    inputNode.size = self.size;
    inputNode.inputSourceDelegate = (id<OGControlInputSourceDelegate>) self.player.input;
    inputNode.position = CGPointZero;
    [self.camera addChild:inputNode];
    
    [self.stateMachine enterState:[OGGameLevelState class]];
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
            door.lockComponent.target = self.player.render.node;
            door.lockComponent.openDistance = 100.0;
            door.lockComponent.closed = YES;
            door.lockComponent.locked = NO;
            [self addEntity:door];
        }
    }
    
    [self createStatusBar];
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

- (void)didBeginContact:(SKPhysicsContact *)contact
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
        id<OGContactNotifiableType> entity = (id<OGContactNotifiableType>) entityA;
        [entity contactWithEntityDidBegin:entityB];
    }

    if ([entityB conformsToProtocol:@protocol(OGContactNotifiableType)] && bNeedsCallback)
    {
        id<OGContactNotifiableType> entity = (id<OGContactNotifiableType>) entityB;
        [entity contactWithEntityDidBegin:entityA];
    }
}

- (void)pause
{
//    [self.playerControlComponent pause];
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
//    [self.playerControlComponent resume];
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
    NSString *sceneFilePath = nil;
    
    sceneFilePath = [[NSBundle mainBundle] pathForResource:kOGMapMenuSceneFileName ofType:kOGSceneFileExtension];
    
    if (sceneFilePath)
    {
        SKScene *nextScene = [NSKeyedUnarchiver unarchiveObjectWithFile:sceneFilePath];
        
        if (nextScene)
        {
            [self.view presentScene:nextScene];
        }
    }
}

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


@end
