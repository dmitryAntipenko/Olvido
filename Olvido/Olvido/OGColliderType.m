//
//  OGColliderType.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGColliderType.h"
#import "OGCollisionBitMask.h"

char *const OGColliderTypeQueueName = "ZEOUniversity.Olvido.InitQueue";

static NSMutableDictionary<NSNumber *, OGColliderType *> *sOGColliderTypes = nil;

static NSMutableDictionary<OGColliderType *, NSMutableArray<OGColliderType *> *> *sOGDefinedCollisions = nil;
static NSMutableDictionary<OGColliderType *, NSMutableArray<OGColliderType *> *> *sOGRequestedContactNotifications = nil;

static dispatch_queue_t initQueue;

@interface OGColliderType ()

@property (nonatomic, assign, readwrite) OGCollisionBitMask categoryBitMask;
@property (nonatomic, assign, readwrite) OGCollisionBitMask collisionBitMask;
@property (nonatomic, assign, readwrite) OGCollisionBitMask contactTestBitMask;

@end

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
        initQueue = dispatch_queue_create(OGColliderTypeQueueName, DISPATCH_QUEUE_SERIAL);
    });
    
    __block OGColliderType *result = sOGColliderTypes[@(bitmask)];
    
    if (!result)
    {        
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
    return [self colliderTypeWithCategoryBitMask:OGCollisionBitMaskPlayer];
}

+ (instancetype)enemy
{
    return [self colliderTypeWithCategoryBitMask:OGCollisionBitMaskEnemy];
}

+ (instancetype)obstacle
{
    return [self colliderTypeWithCategoryBitMask:OGCollisionBitMaskObstacle];
}

+ (instancetype)door
{
    return [self colliderTypeWithCategoryBitMask:OGCollisionBitMaskDoor];
}

+ (instancetype)doorTrigger
{
    return [self colliderTypeWithCategoryBitMask:OGCollisionBitMaskDoorTrigger];
}

+ (instancetype)weapon
{
    return [self colliderTypeWithCategoryBitMask:OGCollisionBitMaskWeapon];
}

+ (instancetype)bullet
{
    return [self colliderTypeWithCategoryBitMask:OGCollisionBitMaskBullet];
}

+ (instancetype)sceneItem
{
    return [self colliderTypeWithCategoryBitMask:OGCollisionBitMaskSceneItem];
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

- (OGCollisionBitMask)findBitMaskInDictionary:(NSDictionary *)dictionary
{
    __block OGCollisionBitMask result = 0;
    
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

- (OGCollisionBitMask)collisionBitMask
{
    return [self findBitMaskInDictionary:sOGDefinedCollisions];
}

- (OGCollisionBitMask)contactTestBitMask
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
