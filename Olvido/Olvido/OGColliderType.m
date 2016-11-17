//
//  OGColliderType.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGColliderType.h"
#import "OGCollisionBitMask.h"

char *const kOGColliderTypeQueueName = "ZEOUniversity.Olvido.InitQueue";

static NSMutableDictionary<NSNumber *, OGColliderType *> *sOGColliderTypes = nil;

static NSMutableDictionary<OGColliderType *, NSMutableArray<OGColliderType *> *> *sOGDefinedCollisions = nil;
static NSMutableDictionary<OGColliderType *, NSMutableArray<OGColliderType *> *> *sOGRequestedContactNotifications = nil;;

@implementation OGColliderType

+ (OGColliderType *)existingColliderTypeWithCategoryBitMask:(OGCollisionBitMask)bitmask
{
    return sOGColliderTypes[@(bitmask)];
}

#pragma mark - Shared Instances

+ (instancetype)colliderTypeWithCategoryBitMask:(OGCollisionBitMask)bitmask
{
    static dispatch_once_t dispatchOnceToken = 0;
    
    dispatch_once(&dispatchOnceToken, ^()
    {
        sOGColliderTypes = [NSMutableDictionary dictionary];
    });
    
    __block OGColliderType *result = sOGColliderTypes[@(bitmask)];
    
    if (!result)
    {
        dispatch_queue_t initQueue = dispatch_queue_create(kOGColliderTypeQueueName, DISPATCH_QUEUE_SERIAL);
        
        dispatch_sync(initQueue, ^()
        {
            result = [[OGColliderType alloc] init];
            result.categoryBitMask = bitmask;
            [sOGColliderTypes setObject:result forKey:@(bitmask)];
        });
    }
    
    return result;
}

+ (instancetype)player
{
    return [self colliderTypeWithCategoryBitMask:kOGCollisionBitMaskPlayer];
}

+ (instancetype)enemy
{
    return [self colliderTypeWithCategoryBitMask:kOGCollisionBitMaskEnemy];
}

+ (instancetype)obstacle
{
    return [self colliderTypeWithCategoryBitMask:kOGCollisionBitMaskObstacle];
}

+ (instancetype)door
{
    return [self colliderTypeWithCategoryBitMask:kOGCollisionBitMaskDoor];
}

+ (instancetype)weapon
{
    return [self colliderTypeWithCategoryBitMask:kOGCollisionBitMaskWeapon];
}

+ (instancetype)bullet
{
    return [self colliderTypeWithCategoryBitMask:kOGCollisionBitMaskBullet];
}

+ (instancetype)key
{
    return [self colliderTypeWithCategoryBitMask:kOGCollisionBitMaskKey];
}

#pragma mark - Lazy getters

+ (NSMutableDictionary *)definedCollisions
{
    if (!sOGDefinedCollisions)
    {
        sOGDefinedCollisions = [[NSMutableDictionary alloc] init];
    }
    
    return sOGDefinedCollisions;
}

+ (NSMutableDictionary *)requestedContactNotifications
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
    __block NSUInteger result = 0;
    
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

#pragma mark - Notifying

- (BOOL)notifyOnContactWith:(OGColliderType *)colliderType
{
    NSArray<OGColliderType *> *requestedContacts = [OGColliderType requestedContactNotifications][self];
    BOOL result = NO;
    
    if ([requestedContacts containsObject:colliderType])
    {
        result = YES;
    }
    
    return result;
}

#pragma mark - CopyWithZone

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
