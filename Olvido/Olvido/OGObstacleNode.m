//
//  OGObstacleNode.m
//  Olvido
//
//  Created by Алексей Подолян on 10/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//
#import "OGObstacleNode.h"
#import "OGCollisionBitMask.h"

@implementation OGObstacleNode

+ (instancetype)obstacleWithColor:(SKColor *)color size:(CGSize)size
{
    OGObstacleNode *obstacle = [[OGObstacleNode alloc] init];
    
    if (obstacle)
    {
        CGRect physicsBodyRect = CGRectMake(-size.width / 2.0,
                                            -size.height / 2.0,
                                            size.width,
                                            size.height);
        
        obstacle.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:physicsBodyRect];
        obstacle.physicsBody.categoryBitMask = kOGCollisionBitMaskObstacle;
        obstacle.physicsBody.contactTestBitMask = kOGCollisionBitMaskPlayer | kOGCollisionBitMaskEnemy;
        obstacle.physicsBody.collisionBitMask = kOGCollisionBitMaskPlayer | kOGCollisionBitMaskEnemy;
        obstacle.physicsBody.usesPreciseCollisionDetection = YES;
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithColor:color size:size];
        [obstacle addChild:sprite];
    }
    
    return [obstacle autorelease];
}

- (void)dealloc
{
    [super dealloc];
}

@end