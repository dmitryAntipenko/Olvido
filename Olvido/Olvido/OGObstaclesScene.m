//
//  OGObstaclesScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGObstaclesScene.h"
#import "OGCollisionBitMask.h"
#import "OGGameScene+OGGameSceneCreation.h"
#import "SKColor+OGConstantColors.h"

@implementation OGObstaclesScene

- (void)createSceneContents
{
    self.backgroundColor = [SKColor gameRed];
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = kOGCollisionBitMaskObstacle;
    self.physicsBody.collisionBitMask = kOGCollisionBitMaskPlayer | kOGCollisionBitMaskEnemy;
    self.physicsBody.contactTestBitMask = kOGCollisionBitMaskPlayer;
    
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    self.physicsWorld.contactDelegate = self;
    
    [self addChild:[self createBackgroundBorderWithColor:[SKColor gameDarkRed]]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.sceneDelegate gameSceneDidCallFinishWithPortal:self.portals[0]];
}

- (void)dealloc
{
    [super dealloc];
}

@end
