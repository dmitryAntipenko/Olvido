//
//  OGZone.m
//  Olvido
//
//  Created by Алексей Подолян on 12/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGZone.h"
#import "OGRenderComponent.h"
#import "OGPhysicsComponent.h"
#import "OGColliderType.h"
#import "OGPeriodicalZone.h"
#import "OGContinuousZone.h"

NSString *const OGZoneDamageType = @"Damage";
NSString *const OGZoneSlowingType = @"Slowing";

@implementation OGZone

#pragma mark - Init

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
               affectingColliderTypes:(NSArray<OGColliderType *> *)affectingColliderTypes
{
    if (spriteNode && affectingColliderTypes)
    {
        self = [super init];
        
        if (self)
        {
            _renderComponent = [[OGRenderComponent alloc] init];
            _renderComponent.sortableByZ = NO;
            _renderComponent.node.position = spriteNode.position;
            _renderComponent.node.zPosition = spriteNode.zPosition;
            
            [self addComponent:_renderComponent];
            
            SKPhysicsBody *physicsBody =  [SKPhysicsBody bodyWithPolygonFromPath:CGPathCreateWithEllipseInRect(CGRectMake(-spriteNode.texture.size.width / 2,
                                                                                                                          -spriteNode.texture.size.height / 2,
                                                                                                                          spriteNode.texture.size.width,
                                                                                                                          spriteNode.texture.size.height),
                                                                                                               nil)];
            
            OGColliderType *colliderType = [OGColliderType zone];
            [[OGColliderType requestedContactNotifications] setObject:affectingColliderTypes forKey:colliderType];
            
            _physicsComponent = [[OGPhysicsComponent alloc] initWithPhysicsBody:physicsBody colliderType:colliderType];
            
            _renderComponent.node.physicsBody = physicsBody;//will removed after physict component add physics body to render node
            
            [self addComponent:_physicsComponent];
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
{
    NSArray *colliderTypes = @[[OGColliderType player], [OGColliderType enemy]];
    return [self initWithSpriteNode:spriteNode affectingColliderTypes:colliderTypes];
}

- (instancetype)init
{
    return [self initWithSpriteNode:nil];
}

#pragma mark - Abstract Methods

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    
}

- (void)contactWithEntityDidEnd:(GKEntity *)entity
{
    
}

- (void)pause
{
    
}

- (void)resume
{
    
}

#pragma mark - FactoryMethods

+ (instancetype)zoneWithSpriteNode:(SKSpriteNode *)spriteNode zoneType:(NSString *)zoneType
{
    OGZone *result = nil;
    
    if ([zoneType isEqualToString:OGZoneDamageType])
    {
        result = [OGPeriodicalZone damageZoneWithSpriteNode:spriteNode];
    }
    
    if ([zoneType isEqualToString:OGZoneSlowingType])
    {
        result = [OGContinuousZone slowZoneWithSpriteNode:spriteNode];
    }
    
    return result;
}

@end
