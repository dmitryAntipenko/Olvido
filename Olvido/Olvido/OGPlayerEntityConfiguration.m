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

- (CGSize)textureSize
{
    return CGSizeMake(120.0, 120.0);
}

- (NSArray<OGAnimation *> *)animations
{
    
}

@end
