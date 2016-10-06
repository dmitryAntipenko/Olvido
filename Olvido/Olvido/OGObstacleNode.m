//
//  OGObstacleNode.m
//  Olvido
//
//  Created by Алексей Подолян on 10/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGObstacleNode.h"

@implementation OGObstacleNode

- (instancetype)obstacleWithColor:(SKColor *)color size:(CGSize)size
{
    OGObstacleNode *obstacle = [[OGObstacleNode alloc] init];
    
    if (obstacle)
    {
        CGRect physicsBodyRect = CGRectMake(-size.width / 2,
                                            -size.height / 2,
                                            size.width,
                                            size.height);
        obstacle.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:physicsBodyRect];
        obstacle.physicsBody.categoryBitMask = 0x0 << 6;//make constant!!
        obstacle.physicsBody.contactTestBitMask = 0x0;
        obstacle.physicsBody.collisionBitMask = 0x0;
        obstacle.physicsBody.usesPreciseCollisionDetection = YES;
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithColor:color size:size];
        [obstacle addChild:sprite];
    }
    
    return [obstacle autorelease];
}

@end
