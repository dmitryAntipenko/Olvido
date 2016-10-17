//
//  OGInitialScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGInitialScene.h"
#import "OGGameScene+OGGameSceneCreation.h"
#import "OGTapMovementControlComponent.h"

NSUInteger const kOGInitialSceneEnemiesCount = 4;

@implementation OGInitialScene

- (void)createSceneContents
{
    self.backgroundColor = [SKColor backgroundLightGrayColor];
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = kOGCollisionBitMaskObstacle;
    self.physicsBody.collisionBitMask = kOGCollisionBitMaskPlayer | kOGCollisionBitMaskEnemy;
    self.physicsBody.contactTestBitMask = kOGCollisionBitMaskPlayer;
    
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    self.physicsWorld.contactDelegate = self;
    
    [self addChild:[self createBackgroundBorderWithColor:[SKColor backgroundGrayColor]]];
    
    [self createEnemies];
    [self createPlayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    
    [self.playerMovementControlComponent didTouchDownAtPoint:touchLocation];
//    OGTransitionComponent *transitionComponent = (OGTransitionComponent *) [self.portals[0] componentForClass:[OGTransitionComponent class]];
//    
//    transitionComponent.closed = NO;
//    
//    [self.sceneDelegate gameSceneDidCallFinishWithPortal:self.portals[0]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    
    [self.playerMovementControlComponent didTouchMoveToPoint:touchLocation];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    
}

- (void)dealloc
{
    [super dealloc];
}

@end
