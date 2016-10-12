//
//  GameScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/27/16.
//  Copyright (c) 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene.h"
#import "SKColor+OGConstantColors.h"

#import "OGTimerNode.h"
#import "OGPlayerNode.h"
#import "OGEnemyNode.h"
#import "OGObstacleNode.h"
#import "OGBonusNode.h"

#import "OGScoreController.h"
#import "OGTimer.h"

#import "OGLevelChanging.h"
#import "OGCollisionBitMask.h"
#import "OGConstants.h"
#import "OGContactType.h"

NSUInteger const kOGGameSceneTimerInterval = 1;
NSUInteger const kOGGameSceneDefaultEnemyCount = 4;
NSUInteger const kOGGameSceneNodesPositionOffset = 50;
NSUInteger const kOGGameSceneBonusNodesMaximumCount = 10;
NSUInteger const kOGGameSceneBonusTypesCount = 4;
NSUInteger const kOGGameSceneBonusDuration = 5;
CGFloat const kOGGameSceneBlurDuration = 1.0;

CGFloat const kOGGameScenePhysicsWorldGameOverSpeed = 0.0;

CGFloat const kOGGameSceneDimPanelFadeAlphaTo = 0.3;
CGFloat const kOGGameSceneDimPanelDuration = 1.0;

CGFloat const kOGGameSceneGameOverScreenFadeInDuration = 1.0;

CGFloat const kOGGameSceneColorizeActionColorBlendFactor = 1.0;
CGFloat const kOGGameSceneColorizeActionDuration = 0.5;

CGFloat const kOGGameSceneBonusBlinkActionBeforeScaleTo = 1.2;
CGFloat const kOGGameSceneBonusBlinkActionBeforeDuration  = 2.0;
CGFloat const kOGGameSceneBonusBlinkActionAfterScaleTo = 1.0;
CGFloat const kOGGameSceneBonusBlinkActionAfterDuration  = 2.0;

CGFloat const kOGGameSceneBonusSlowMoPhysicsWorldSpeed = 0.6;
CGFloat const kOGGameSceneBonusSpeedUpPhysicsWorldSpeed = 1.4;
CGFloat const kOGGameScenePhysicsWorldDefaultSpeed = 1.0;

CGFloat const kOGGameSceneSpeedUpFactor = 1.5;
CGFloat const kOGGameSceneSlowDownFactor = 0.7;

@interface OGGameScene () <SKPhysicsContactDelegate>

@property (nonatomic, retain) OGScoreController *scoreController;

@property (nonatomic, getter=isSceneCreated) BOOL sceneCreated;

@end

@implementation OGGameScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.isSceneCreated)
    {
        self.backgroundColor = [SKColor backgroundLightGrayColor];
        
        [self createDefaultValues];
        [self createSceneContents];
        self.sceneCreated = YES;
    }
}

#pragma mark - Scene creation

- (void)createDefaultValues
{

}

- (void)createSceneContents
{
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = kOGCollisionBitMaskObstacle;
    self.physicsBody.collisionBitMask = kOGCollisionBitMaskPlayer | kOGCollisionBitMaskEnemy;
    self.physicsBody.contactTestBitMask = kOGCollisionBitMaskPlayer;
    
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    self.physicsWorld.contactDelegate = self;
    
    [self createLayers];
}

- (void)createLayers
{

}

#pragma mark - Touches detection

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:location];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //...
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //...
}

#pragma mark - Collision detection

- (void)didBeginContact:(SKPhysicsContact *)contact
{

}

- (void)update:(CFTimeInterval)currentTime
{

}

- (void)dealloc
{
    [_scoreController release];
    
    [super dealloc];
}

@end
