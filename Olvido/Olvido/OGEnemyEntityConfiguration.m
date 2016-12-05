//
//  OGEnemyEntityConfiguration.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyEntityConfiguration.h"
#import "OGCollisionBitMask.h"

@implementation OGEnemyEntityConfiguration

- (CGFloat)physicsBodyRadius
{
    return 30.0;
}

+ (NSTimeInterval)maxPredictionTimeForObstacleAvoidance
{
    return 1.0;
}

+ (CGFloat)pathfindingGraphBufferRadius
{
    return 30.0;
}

@end
