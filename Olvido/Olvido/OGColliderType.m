//
//  OGColliderType.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGColliderType.h"
#import "OGCollisionBitMask.h"

static NSMutableDictionary<OGColliderType *, NSArray<OGColliderType *> *> *sOGDefinedCollisions;
static NSMutableDictionary<OGColliderType *, NSArray<OGColliderType *> *> *sOGRequestedContactNotifications;

//@interface OGColliderType ()
//
//@end

@implementation OGColliderType

#pragma mark - Shared Instances

+ (OGColliderType *)sharedInstanceWithCategoryBitMask:(NSUInteger)bitmask
{
    static OGColliderType *colliderType = nil;
    static dispatch_once_t dispatchOnceToken = 0;
    
    dispatch_once(&dispatchOnceToken, ^()
    {
        colliderType = [[self alloc] init];
        colliderType.categoryBitMask = bitmask;
    });
    
    return colliderType;
}

+ (OGColliderType *)player
{
    return [OGColliderType sharedInstanceWithCategoryBitMask:kOGCollisionBitMaskPlayer];
}

+ (OGColliderType *)enemy
{
    return [OGColliderType sharedInstanceWithCategoryBitMask:kOGCollisionBitMaskEnemy];
}

#pragma mark - Lazy getters

+ (NSDictionary *)sOGDefinedCollisions
{
    if (!sOGDefinedCollisions)
    {
        sOGDefinedCollisions = [[NSMutableDictionary alloc] init];
    }
    
    return sOGDefinedCollisions;
}

+ (NSDictionary *)sOGRequestedContactNotifications
{
    if (!sOGRequestedContactNotifications)
    {
        sOGRequestedContactNotifications = [[NSMutableDictionary alloc] init];
    }
    
    return sOGRequestedContactNotifications;
}

#pragma mark - Getters

- (NSUInteger)findBitMaskInDictionary:(NSDictionary *)dictionary
{
    __block NSUInteger result;
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(OGColliderType *key, NSArray *obj, BOOL *stop)
     {
         if (key.categoryBitMask == self.categoryBitMask)
         {
             for (OGColliderType *colliderType in obj)
             {
                 result = result | colliderType.categoryBitMask;
             }
             
             *stop = YES;
         }
     }];
    
    return result;
}

- (NSUInteger)collisionBitMask
{
    return [self findBitMaskInDictionary:sOGDefinedCollisions];
}

- (NSUInteger)contactTestBitMask
{
    return [self findBitMaskInDictionary:sOGRequestedContactNotifications];
}

#pragma mark - CopyWithZone

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
