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

@property (nonatomic, assign, readonly) OGCollisionBitMask categoryBitMask;
@property (nonatomic, assign, readonly) OGCollisionBitMask collisionBitMask;
@property (nonatomic, assign, readonly) OGCollisionBitMask contactTestBitMask;

+ (instancetype)player;
+ (instancetype)enemy;
+ (instancetype)obstacle;
+ (instancetype)door;
+ (instancetype)doorTrigger;
+ (instancetype)weapon;
+ (instancetype)bullet;
+ (instancetype)key;
+ (instancetype)zone;

+ (OGColliderType *)existingColliderTypeWithCategoryBitMask:(OGCollisionBitMask)bitmask;

+ (NSMutableDictionary *)definedCollisions;
+ (NSMutableDictionary *)requestedContactNotifications;

- (BOOL)notifyOnContactWith:(OGColliderType *)colliderType;

@end
