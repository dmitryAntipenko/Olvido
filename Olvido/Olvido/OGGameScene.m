//
//  OGGameScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene.h"
#import "OGContactType.h"
#import "OGCollisionBitMask.h"
#import "OGSpriteNode.h"
#import "OGConstants.h"

#import "OGTransitionComponent.h"
#import "OGAccessComponent.h"
#import "OGHealthComponent.h"
#import "OGInventoryComponent.h"
#import "OGDestroyableComponent.h"

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

@property (nonatomic, retain) NSMutableArray<OGSpriteNode *> *mutableSpriteNodes;
@property (nonatomic, retain) GKStateMachine *stateMachine;
@property (nonatomic, retain) SKReferenceNode *pauseScreenNode;
@property (nonatomic, retain) SKReferenceNode *gameOverScreenNode;

@end

@implementation OGGameScene

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (aDecoder)
    {
        self = [super initWithCoder:aDecoder];
        
        if (self)
        {
            _mutableSpriteNodes = [[NSMutableArray alloc] init];
            _stateMachine = [[GKStateMachine alloc] initWithStates:@[
                                                                     [OGStoryConclusionLevelState stateWithLevelScene:self],
                                                                     [OGBeforeStartLevelState stateWithLevelScene:self],
                                                                     [OGGameLevelState stateWithLevelScene:self],
                                                                     [OGPauseLevelState stateWithLevelScene:self],
                                                                     [OGCompleteLevelState stateWithLevelScene:self],
                                                                     [OGDeathLevelState stateWithLevelScene:self]
                                                                     ]];
            _statusBar = [[OGStatusBar alloc] init];
            
            _pauseScreenNode = [[SKReferenceNode alloc] initWithFileNamed:kOGGameScenePauseScreenNodeName];
            _gameOverScreenNode = [[SKReferenceNode alloc] initWithFileNamed:kOGGameSceneGameOverScreenNodeName];
        }
    }
    else
    {
        [self release];
        self = nil;
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    self.physicsWorld.contactDelegate = self;
    
    for (OGSpriteNode *sprite in self.spriteNodes)
    {
        if ([sprite.name isEqualToString:kOGPlayerSpriteName])
        {
            OGMovementControlComponent *controlComponent = (OGMovementControlComponent *) [sprite.entity componentForClass:[OGMovementControlComponent class]];
            self.playerControlComponent = controlComponent;
            
            OGHealthComponent *healthComponent = (OGHealthComponent *) [sprite.entity componentForClass:[OGHealthComponent class]];
            self.healthComponent = healthComponent;
            
            OGInventoryComponent *inventoryComponent = (OGInventoryComponent *) [sprite.entity componentForClass:[OGInventoryComponent class]];
            self.inventoryComponent = inventoryComponent;
            
            OGAnimationComponent *animationComponent = (OGAnimationComponent *)[sprite.entity componentForClass:[OGAnimationComponent class]];
            self.playerAnimationComponent = animationComponent;
            
            OGLevelController *levelController = [OGLevelController sharedInstance];
            
            if ([levelController.controlType isEqualToString:kOGLevelControllerTapContinueControl])
            {
                OGTapMovementControlComponent *tapMovementComponent = [[OGTapMovementControlComponent alloc] init];
                tapMovementComponent.speedFactor = 1.0;
                [sprite.entity addComponent:tapMovementComponent];
                
                self.playerControlComponent = tapMovementComponent;
                
                [tapMovementComponent release];
            }
            else if ([levelController.controlType isEqualToString:kOGLevelControllerTapStopControl])
            {
                OGTapAndStopMovementControlComponent *tapAndStopMovementComponent = [[OGTapAndStopMovementControlComponent alloc] init];
                tapAndStopMovementComponent.speedFactor = 1.0;
                [sprite.entity addComponent:tapAndStopMovementComponent];
                
                self.playerControlComponent = tapAndStopMovementComponent;
                
                [tapAndStopMovementComponent release];
            }
            else if ([levelController.controlType isEqualToString:kOGLevelControllerDragControl])
            {
                OGDragMovementControlComponent *dragMovementComponent = [[OGDragMovementControlComponent alloc] init];
                [sprite.entity addComponent:dragMovementComponent];
                
                self.playerControlComponent = dragMovementComponent;
                
                [dragMovementComponent release];
            }
            
        }
        else if ([sprite.name isEqualToString:kOGPortalSpriteName])
        {
            OGAccessComponent *accessComponent = (OGAccessComponent *) [sprite.entity componentForClass:[OGAccessComponent class]];
            self.accessComponent = accessComponent;
            
            OGTransitionComponent *transitionComponent = (OGTransitionComponent *) [sprite.entity componentForClass:[OGTransitionComponent class]];
            self.transitionComponent = transitionComponent;
        }
        else if ([sprite.name isEqualToString:kOGEnemySpriteName])
        {
            OGAnimationState *animationState = [OGAnimationState animationStateWithName:@"mooving"
                                                                               textures:@[
                                                                                          [SKTexture textureWithImageNamed:@"Zombie Right 1"],
                                                                                          [SKTexture textureWithImageNamed:@"Zombie Right 2"]
                                                                                          ]
                                                                        validNextStates:nil];
            
            OGAnimationComponent *animationComponent = (OGAnimationComponent *)[sprite.entity componentForClass:[OGAnimationComponent class]];
            [animationComponent playNextAnimationState:animationState];
        }
    }
    
    [self createStatusBar];
    
    [self.stateMachine enterState:[OGGameLevelState class]];
    
    [super didMoveToView:view];
}

- (void)createStatusBar
{
    SKSpriteNode *statusBar = (SKSpriteNode *) [self childNodeWithName:kOGGameSceneStatusBarSpriteName];
    
    if (statusBar)
    {
        self.statusBar.statusBarSprite = statusBar;
        self.statusBar.healthComponent = self.healthComponent;
        [self.statusBar createContents];
    }
}

- (NSArray *)spriteNodes
{
    return [[self.mutableSpriteNodes copy] autorelease];
}

- (void)addSpriteNode:(OGSpriteNode *)spriteNode
{
    if (spriteNode)
    {
        [self.mutableSpriteNodes addObject:spriteNode];
    }
}

#pragma mark - Contact handling

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    OGSpriteNode *touchedBody = nil;
    OGContactType contactType = [self contactType:contact withBody:&touchedBody];
    
    if (contactType == kOGContactTypeGameOver)
    {
        [self.stateMachine enterState:[OGDeathLevelState class]];
    }
    else if (contactType == kOGContactTypePlayerDidGrantAccess)
    {
        [self.accessComponent grantAccessWithCompletionBlock:^()
         {
             self.transitionComponent.closed = NO;
             [touchedBody removeFromParent];
         }];
    }
    else if (contactType == kOGContactTypePlayerDidTouchPortal && !self.transitionComponent.isClosed)
    {
        [self.sceneDelegate gameSceneDidCallFinish];
    }
}

- (OGContactType)contactType:(SKPhysicsContact *)contact withBody:(SKNode **)body
{
    SKPhysicsBody *bodyA = nil;
    SKPhysicsBody *bodyB = nil;
    OGContactType result = kOGContactTypeNone;
    
    [self contact:contact toBodyA:&bodyA bodyB:&bodyB];
    [self checkDestroyableWithBodyA:&bodyA bodyB:&bodyB];
    
    if (bodyA.categoryBitMask == kOGCollisionBitMaskEnemy
        || bodyB.categoryBitMask == kOGCollisionBitMaskEnemy)
    {
        result = kOGContactTypeGameOver;
    }
    else if (bodyA.categoryBitMask == kOGCollisionBitMaskCoin)
    {
        *body = bodyA.node;
        result = kOGContactTypePlayerDidGetCoin;
    }
    else if (bodyB.categoryBitMask == kOGCollisionBitMaskCoin)
    {
        *body = bodyB.node;
        result = kOGContactTypePlayerDidGetCoin;
    }
    else if (bodyA.categoryBitMask == kOGCollisionBitMaskPortal)
    {
        *body = bodyA.node;
        result = kOGContactTypePlayerDidTouchPortal;
    }
    else if (bodyB.categoryBitMask == kOGCollisionBitMaskPortal)
    {
        *body = bodyB.node;
        result = kOGContactTypePlayerDidTouchPortal;
    }
    else if (bodyB.categoryBitMask == kOGCollisionBitMaskObstacle
             && bodyA.categoryBitMask == kOGCollisionBitMaskPlayer)
    {
        *body = bodyA.node;
        result = kOGContactTypePlayerDidTouchObstacle;
    }
    else if (bodyA.categoryBitMask == kOGCollisionBitMaskObstacle
             && bodyB.categoryBitMask == kOGCollisionBitMaskPlayer)
    {
        *body = bodyB.node;
        result = kOGContactTypePlayerDidTouchObstacle;
    }
    else if (bodyB.categoryBitMask == kOGCollisionBitMaskKey
             && bodyA.categoryBitMask == kOGCollisionBitMaskPlayer)
    {
        *body = bodyB.node;
        result = kOGContactTypePlayerDidGrantAccess;
    }
    else if (bodyA.categoryBitMask == kOGCollisionBitMaskKey
             && bodyB.categoryBitMask == kOGCollisionBitMaskPlayer)
    {
        *body = bodyA.node;
        result = kOGContactTypePlayerDidGrantAccess;
    }
    
    return result;
}

- (void)checkDestroyableWithBodyA:(SKPhysicsBody **)bodyA bodyB:(SKPhysicsBody **)bodyB
{
    OGDestroyableComponent *destroyableComponentBodyA = (OGDestroyableComponent *) [(*bodyA).node.entity componentForClass:[OGDestroyableComponent class]];
    OGDestroyableComponent *destroyableComponentBodyB = (OGDestroyableComponent *) [(*bodyB).node.entity componentForClass:[OGDestroyableComponent class]];
    
    if (destroyableComponentBodyA)
    {
        [destroyableComponentBodyA dealDamage:1];
    }
    
    if (destroyableComponentBodyB)
    {
        [destroyableComponentBodyB dealDamage:1];
    }
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
    [self.playerControlComponent pause];
    self.physicsWorld.speed = kOGGameScenePauseSpeed;
    self.speed = kOGGameScenePauseSpeed;
    self.paused = YES;
}

- (void)showPauseScreen
{
    if (!self.pauseScreenNode.parent)
    {
        [self addChild:self.pauseScreenNode];
    }
}

- (void)resume
{
    [self.playerControlComponent resume];
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

- (void)update:(NSTimeInterval)currentTime
{
    
}

- (void)dealloc
{
    [_identifier release];
    [_mutableSpriteNodes release];
    [_accessComponent release];
    [_playerControlComponent release];
    [_transitionComponent release];
    [_playerAnimationComponent release];
    [_stateMachine release];
    
    [_pauseScreenNode release];
    [_gameOverScreenNode release];
    
    [_healthComponent release];
    [_statusBar release];
    [_inventoryComponent release];
    
    [super dealloc];
}

@end
