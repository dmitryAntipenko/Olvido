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

+ (OGColliderType *)player;
+ (OGColliderType *)enemy;

+ (NSDictionary *)sOGDefinedCollisions;
+ (NSDictionary *)sOGRequestedContactNotifications;

@end

//struct OGColliderType
//{
//    uint32_t categoryBitMask;
//    uint32_t collisionBitMask;
//    uint32_t contactTestBitMask;
//    NSUInteger angularDamping;
//    NSUInteger linearDamping;
//    NSUInteger friction;
//    NSUInteger restitution;
//};

//extern const struct OGColliderType colliderType;
