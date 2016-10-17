//
//  OGInitialScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGInitialScene.h"
#import "OGGameScene+OGGameSceneCreation.h"

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
    OGTransitionComponent *transitionComponent = (OGTransitionComponent *) [self.portals[0] componentForClass:[OGTransitionComponent class]];
    
    transitionComponent.closed = NO;
    
    [self.sceneDelegate gameSceneDidCallFinishWithPortal:self.portals[0]];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@" a : %@, B : %@", contact.bodyA.node.name, contact.bodyB.node.name);
}

- (void)dealloc
{
    [super dealloc];
}

@end
