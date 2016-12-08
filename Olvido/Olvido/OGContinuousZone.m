//
//  OGContinuousZone.m
//  Olvido
//
//  Created by Алексей Подолян on 12/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGContinuousZone.h"
#import "OGMovementComponent.h"

CGFloat const OGContinuousSlowZoneSlowSpeedAccelerationCoefficient = 0.5;
CGFloat const OGContinuousSlowZoneDefaultSpeedAccelerationCoefficient = 2.0;

@interface OGContinuousZone ()

@property (nonatomic, strong) void (^didBeginContactBlock)(GKEntity *entity);
@property (nonatomic, strong) void (^didEndContactBlock)(GKEntity *entity);

@end

@implementation OGContinuousZone

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
            affectingColliderTypes:(NSArray<OGColliderType *> *)affectingColliderTypes
              didBeginContactBlock:(void (^)(GKEntity *entity))didBeginContactBlock
                didEndContactBlock:(void (^)(GKEntity *entity))didEndContactBlock
{
    if (didBeginContactBlock && didBeginContactBlock)
    {
        self = [self initWithSpriteNode:spriteNode affectingColliderTypes:affectingColliderTypes];
        
        if (self)
        {
            _didBeginContactBlock = didBeginContactBlock;
            _didEndContactBlock = didEndContactBlock;
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
              didBeginContactBlock:(void (^)(GKEntity *entity))didBeginContactBlock
                didEndContactBlock:(void (^)(GKEntity *entity))didEndContactBlock
{
    if (didBeginContactBlock && didBeginContactBlock)
    {
        self = [self initWithSpriteNode:spriteNode];
        
        if (self)
        {
            _didBeginContactBlock = didBeginContactBlock;
            _didEndContactBlock = didEndContactBlock;
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

#pragma mark - OGContactNotifiableType

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    self.didBeginContactBlock(entity);
}

- (void)contactWithEntityDidEnd:(GKEntity *)entity
{
    self.didEndContactBlock(entity);
}

#pragma mark - Factory methods

+ (instancetype)slowZoneWithSpriteNode:(SKSpriteNode *)spriteNode
{
    void (^beginContactBlock)(GKEntity *entity) = ^(GKEntity *entity)
    {
        OGMovementComponent *movementComponent = (OGMovementComponent *)[entity componentForClass:[OGMovementComponent class]];
        movementComponent.speedFactor *= OGContinuousSlowZoneSlowSpeedAccelerationCoefficient;
    };
    
    void (^endContactBlock)(GKEntity *entity) = ^(GKEntity *entity)
    {
        OGMovementComponent *movementComponent = (OGMovementComponent *)[entity componentForClass:[OGMovementComponent class]];
        movementComponent.speedFactor *= OGContinuousSlowZoneDefaultSpeedAccelerationCoefficient;
    };
    
    return [[self alloc] initWithSpriteNode:spriteNode
                       didBeginContactBlock:beginContactBlock
                         didEndContactBlock:endContactBlock];
}

@end
