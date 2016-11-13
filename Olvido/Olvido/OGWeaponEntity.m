//
//  OGBlaster.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/12/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGWeaponEntity.h"
#import "OGRenderComponent.h"
#import "OGPhysicsComponent.h"

NSString *const kOGWeaponEntityDefaultInventoryIdentifier = @"weapon";

@implementation OGWeaponEntity

- (instancetype)initWithSpriteNode:(SKSpriteNode *)sprite
{
    self = [super init];

    if (self)
    {
        NSMutableArray *collisionColliders = [NSMutableArray arrayWithObjects:[OGColliderType obstacle], nil];
        [[OGColliderType definedCollisions] setObject:collisionColliders forKey:[OGColliderType weapon]];
        
        _render = [[OGRenderComponent alloc] init];
        _render.node = sprite;
        [self addComponent:_render];
        
        _physics = [[OGPhysicsComponent alloc] initWithPhysicsBody:sprite.physicsBody
                                                      colliderType:[OGColliderType weapon]];
        [self addComponent:_physics];
    }
    
    return self;
}

#pragma mark - OGAttacking

- (void)attack
{
    NSLog(@"shoot");
}

- (BOOL)canAttack
{
    return YES;
}

#pragma mark - OGInventoryItemProtocol

- (NSString *)inventoryIdentifier
{
    return kOGWeaponEntityDefaultInventoryIdentifier;
}

- (SKNode *)itemNode
{
    return self.render.node;
}

@end
