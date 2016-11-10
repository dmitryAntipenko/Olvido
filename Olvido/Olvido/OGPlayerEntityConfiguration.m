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

- (CGFloat)physicsBodyRadius
{
    return 30.0;
}

- (CGFloat)messageShowDistance
{
    return 50.0;
}

@end
