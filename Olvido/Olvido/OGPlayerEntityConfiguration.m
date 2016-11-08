//
//  OGPlayerEntityConfiguration.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerEntityConfiguration.h"
#import "OGCollisionBitMask.h"

@implementation OGPlayerEntityConfiguration

- (NSUInteger)maxHealth
{
    return 3;
}

- (NSUInteger)currentHealth
{
    return 3;
}

- (struct OGColliderType)colliderType
{
    struct OGColliderType result;
    
    result.categoryBitMask = kOGCollisionBitMaskPlayer;
    result.collisionBitMask = kOGCollisionBitMaskObstacle;
    result.contactTestBitMask = kOGCollisionBitMaskEnemy | kOGCollisionBitMaskPortal;
    result.angularDamping = 0.0;
    result.linearDamping = 0.0;
    result.restitution = 0.8;
    result.friction = 0.2;
    
    return result;
}

- (CGFloat)physicsBodyRadius
{
    return 30.0;
}

- (CGFloat)messageShowDistance
{
    return 50.0;
}

@end
