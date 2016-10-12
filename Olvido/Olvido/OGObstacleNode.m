//
//  OGObstacleNode.m
//  Olvido
//
//  Created by Алексей Подолян on 10/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//
#import "OGObstacleNode.h"
#import "OGCollisionBitMask.h"
#import "OGConstants.h"

@implementation OGObstacleNode

+ (instancetype)obstacleNodeWithColor:(SKColor *)color path:(CGPathRef)path;
{
    OGObstacleNode *obstacle = [[OGObstacleNode alloc] init];
    
    if (obstacle)
    {        
        obstacle.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path];
        obstacle.physicsBody.categoryBitMask = kOGCollisionBitMaskObstacle;
        obstacle.physicsBody.contactTestBitMask = kOGCollisionBitMaskDefault;
        obstacle.physicsBody.collisionBitMask = kOGCollisionBitMaskDefault;
        obstacle.physicsBody.usesPreciseCollisionDetection = YES;
        
        SKShapeNode* shape = [SKShapeNode shapeNodeWithPath:path];
        shape.fillColor = color;
        shape.strokeColor = color;
        
        [obstacle addChild:shape];
    }
    
    return [obstacle autorelease];
}

@end
