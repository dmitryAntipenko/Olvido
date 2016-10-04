//
//  GameScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/27/16.
//  Copyright (c) 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene.h"
#import "SKColor+OGConstantColors.h"
#import "OGGameScene+OGGameSceneCreation.h"
#import "OGTimerNode.h"

@interface OGGameScene () <SKPhysicsContactDelegate>

@property (nonatomic, retain) SKNode *background;
@property (nonatomic, retain) SKNode *middleground;
@property (nonatomic, retain) SKNode *foreground;

@property (nonatomic, retain) OGTimerNode *timerNode;
@property (nonatomic, getter=isPlayerDragStarted) BOOL playerDragStart;
@property (nonatomic, getter=isSceneCreated) BOOL sceneCreated;

@end

@implementation OGGameScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.isSceneCreated)
    {
        self.backgroundColor = [SKColor backgroundLightGrayColor];
        
        [self createSceneContents];
        self.sceneCreated = YES;
    }
}

- (void)createSceneContents
{
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = 0x1 << 0;
    self.physicsBody.contactTestBitMask = 0x0;
    
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    self.physicsWorld.contactDelegate = self;
    
    [self createLayers];
}

- (void)createLayers
{
    self.background = [self createBackground];
    [self addChild:self.background];
    
    self.middleground = [self createMiddleGround];
    [self addChild:self.middleground];
    
    self.foreground = [self createForeground];
    [self addChild:self.foreground];
    
    self.timerNode = (OGTimerNode *) [self.middleground childNodeWithName:kOGTimerNodeName];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //...
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //...
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //...
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    //...
}

- (void)showGameOverScreen
{
    self.physicsWorld.speed = 0.0;
    [self.timerNode.timer stop];
    
    SKNode *dimPanel = [self createDimPanel];
    [self addChild:dimPanel];
    
    SKNode *gameOverScreen = [self createGameOverScreenWithScore:self.timerNode.timer.ticks];
    [self addChild:gameOverScreen];
    
    [dimPanel runAction:[SKAction fadeAlphaTo:0.3 duration:1.0]];
    [gameOverScreen runAction:[SKAction fadeInWithDuration:1.0]];
}

- (void)update:(CFTimeInterval)currentTime
{
    //...
}

@end
