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

#import "OGPlayerEntity.h"
#import "OGRenderComponent.h"
#import "OGMovementComponent.h"
#import "OGIntelligenceComponent.h"
#import "OGAnimationComponent.h"

#import "OGStatusBar.h"

#import "OGBeforeStartLevelState.h"
#import "OGStoryConclusionLevelState.h"
#import "OGGameLevelState.h"
#import "OGPauseLevelState.h"
#import "OGCompleteLevelState.h"
#import "OGDeathLevelState.h"

#import "OGLevelController.h"
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
                             [[GKComponentSystem alloc] initWithComponentClass:OGAnimationComponent.class],
                             [[GKComponentSystem alloc] initWithComponentClass:OGMovementComponent.class],
                             [[GKComponentSystem alloc] initWithComponentClass:OGIntelligenceComponent.class],
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
    
    self.physicsWorld.contactDelegate = self;
    self.lastUpdateTimeInterval = 0.0;
    
    [self addEntity:self.player];
    SKNode *playerInitialNode = [self childNodeWithName:@"player_initial_position"];
    self.player.render.node.position = playerInitialNode.position;
    
    [self createStatusBar];
    
    [self.stateMachine enterState:[OGGameLevelState class]];
    
    OGTouchControlInputNode *inputNode = [[OGTouchControlInputNode alloc] initWithFrame:self.frame thumbStickNodeSize:CGSizeMake(200.0, 200.0)];
    inputNode.size = self.size;
    inputNode.inputSourceDelegate = (id<OGControlInputSourceDelegate>) self.player.input;
    [self addChild:inputNode];
}

- (void)addEntity:(GKEntity *)entity
{
    [self.entities addObject:entity];
    
    for (GKComponentSystem *componentSystem in self.componentSystems)
    {
        [componentSystem addComponentWithEntity:entity];
    }
    
    SKNode *renderNode = ((OGRenderComponent *) [entity componentForClass:OGRenderComponent.class]).node;
    
    if (renderNode)
    {
        [self addChild:renderNode];
    }
    
    OGIntelligenceComponent *intelligenceComponent = (OGIntelligenceComponent *) [entity componentForClass:OGIntelligenceComponent.class];
    
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
//        self.statusBar.healthComponent = self.healthComponent;
        [self.statusBar createContents];
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"%@", contact);
}

- (void)contact:(SKPhysicsContact *)contact toBodyA:(SKPhysicsBody **)bodyA bodyB:(SKPhysicsBody **)bodyB
{
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        *bodyA = contact.bodyA;
        *bodyB = contact.bodyB;
    }
    else
    {
        *bodyA = contact.bodyB;
        *bodyB = contact.bodyA;
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
    
    CGFloat deltaTime = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;

    for (GKComponentSystem *componentSystem in self.componentSystems)
    {
        [componentSystem updateWithDeltaTime:deltaTime];
    }
}


@end
