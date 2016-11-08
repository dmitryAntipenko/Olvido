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

- (struct OGColliderType)colliderType
{
    struct OGColliderType result;
    
    result.categoryBitMask = kOGCollisionBitMaskEnemy;
    result.collisionBitMask = kOGCollisionBitMaskObstacle;
    result.contactTestBitMask = kOGCollisionBitMaskPlayer | kOGCollisionBitMaskObstacle;
    result.angularDamping = 0.0;
    result.linearDamping = 0.0;
    result.restitution = 0.8;
    result.friction = 0.2;
    
    return result;
}

@end
