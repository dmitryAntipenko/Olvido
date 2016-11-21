//
//  OGColliderType.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OGColliderType : NSObject <NSCopying>

@property (nonatomic, assign) NSUInteger categoryBitMask;
@property (nonatomic, assign) NSUInteger collisionBitMask;
@property (nonatomic, assign) NSUInteger contactTestBitMask;

+ (OGColliderType *)colliderTypeWithCategoryBitMask:(NSUInteger)bitmask;

+ (OGColliderType *)player;
+ (OGColliderType *)enemy;
+ (OGColliderType *)obstacle;
+ (OGColliderType *)door;
+ (OGColliderType *)weapon;
+ (OGColliderType *)bullet;

+ (NSMutableDictionary *)definedCollisions;
+ (NSMutableDictionary *)requestedContactNotifications;

- (BOOL)notifyOnContactWith:(OGColliderType *)colliderType;

@end
