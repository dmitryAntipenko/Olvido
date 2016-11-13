//
//  OGColliderType.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGColliderType.h"
#import "OGCollisionBitMask.h"

static NSMutableDictionary<OGColliderType *, NSMutableArray<OGColliderType *> *> *sOGDefinedCollisions;
static NSMutableDictionary<OGColliderType *, NSMutableArray<OGColliderType *> *> *sOGRequestedContactNotifications;

@implementation OGColliderType

#pragma mark - Shared Instances

+ (OGColliderType *)colliderTypeWithCategoryBitMask:(NSUInteger)bitmask
{
    OGColliderType *result = nil;
    
    switch (bitmask)
    {
        case kOGCollisionBitMaskPlayer:
            result = [OGColliderType player];
            break;
            
        case kOGCollisionBitMaskEnemy:
            result = [OGColliderType enemy];
            break;
            
        case kOGCollisionBitMaskObstacle:
            result = [OGColliderType obstacle];
            break;
            
        case kOGCollisionBitMaskWeapon:
            result = [OGColliderType weapon];
            break;
            
        case kOGCollisionBitMaskDoor:
            result = [OGColliderType door];
            break;
    }
    
    return result;
}

+ (OGColliderType *)player
{
    static OGColliderType *colliderType = nil;
    static dispatch_once_t dispatchOnceToken = 0;
    
    dispatch_once(&dispatchOnceToken, ^()
    {
        colliderType = [[self alloc] init];
        colliderType.categoryBitMask = kOGCollisionBitMaskPlayer;
    });
    
    return colliderType;
}

+ (OGColliderType *)enemy
{
    static OGColliderType *colliderType = nil;
    static dispatch_once_t dispatchOnceToken = 0;
    
    dispatch_once(&dispatchOnceToken, ^()
    {
        colliderType = [[self alloc] init];
        colliderType.categoryBitMask = kOGCollisionBitMaskEnemy;
    });
    
    return colliderType;
}

+ (OGColliderType *)obstacle
{
    static OGColliderType *colliderType = nil;
    static dispatch_once_t dispatchOnceToken = 0;
    
    dispatch_once(&dispatchOnceToken, ^()
    {
        colliderType = [[self alloc] init];
        colliderType.categoryBitMask = kOGCollisionBitMaskObstacle;
    });
    
    return colliderType;
}

+ (OGColliderType *)door
{
    static OGColliderType *colliderType = nil;
    static dispatch_once_t dispatchOnceToken = 0;
    
    dispatch_once(&dispatchOnceToken, ^()
    {
        colliderType = [[self alloc] init];
        colliderType.categoryBitMask = kOGCollisionBitMaskDoor;
    });
    
    return colliderType;
}

+ (OGColliderType *)weapon
{
    static OGColliderType *colliderType = nil;
    static dispatch_once_t dispatchOnceToken = 0;
    
    dispatch_once(&dispatchOnceToken, ^()
    {
        colliderType = [[self alloc] init];
        colliderType.categoryBitMask = kOGCollisionBitMaskWeapon;
    });
    
    return colliderType;
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
