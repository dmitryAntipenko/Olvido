//
//  OGColliderType.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGCollisionBitMask.h"

@interface OGColliderType : NSObject <NSCopying>

@property (nonatomic, assign) NSUInteger categoryBitMask;
@property (nonatomic, assign) NSUInteger collisionBitMask;
@property (nonatomic, assign) NSUInteger contactTestBitMask;

+ (instancetype)player;
+ (instancetype)enemy;
+ (instancetype)obstacle;
+ (instancetype)door;
+ (instancetype)doorTrigger;
+ (instancetype)weapon;
+ (instancetype)bullet;
+ (instancetype)key;

+ (OGColliderType *)existingColliderTypeWithCategoryBitMask:(OGCollisionBitMask)bitmask;

+ (NSMutableDictionary *)definedCollisions;
+ (NSMutableDictionary *)requestedContactNotifications;

- (BOOL)notifyOnContactWith:(OGColliderType *)colliderType;

@end
