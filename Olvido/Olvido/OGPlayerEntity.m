//
//  OGPlayerEntity.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerEntity.h"
#import "OGRenderComponent.h"
#import "OGHealthComponent.h"
#import "OGIntelligenceComponent.h"
#import "OGInputComponent.h"
#import "OGMovementComponent.h"
#import "OGAnimationComponent.h"
#import "OGPhysicsComponent.h"
#import "OGMessageComponent.h"
#import "OGOrientationComponent.h"
#import "OGWeaponComponent.h"
#import "OGInventory.h"
#import "OGInventoryItemProtocol.h"
#import "OGPlayerEntity+OGPlayerEntityResources.h"

#import "OGColliderType.h"

#import "OGPlayerEntityConfiguration.h"
#import "OGAnimationState.h"

#import "OGPlayerEntityAppearState.h"
#import "OGplayerEntityControlledState.h"
#import "OGplayerEntityAttackState.h"

CGFloat const kOGPlayerEntityWeaponDropDelay = 1.0;

@interface OGPlayerEntity ()

@property (nonatomic, strong) OGPlayerEntityConfiguration *playerConfiguration;
@property (nonatomic, assign) BOOL canTakeWeapon;

@end

@implementation OGPlayerEntity

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _inventory = [[OGInventory alloc] init];
        
        _playerConfiguration = [[OGPlayerEntityConfiguration alloc] init];
        
        _render = [[OGRenderComponent alloc] init];
        [self addComponent:_render];
        
        _physics = [[OGPhysicsComponent alloc] initWithPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:_playerConfiguration.physicsBodyRadius]
                                                      colliderType:[OGColliderType player]];
        [self addComponent:_physics];
        
        _render.node.physicsBody = _physics.physicsBody;
        _render.node.physicsBody.allowsRotation = NO;
        
        _health = [[OGHealthComponent alloc] init];
        _health.maxHealth = _playerConfiguration.maxHealth;
        _health.currentHealth = _playerConfiguration.currentHealth;
        [self addComponent:_health];
        
        _movement = [[OGMovementComponent alloc] init];
        [self addComponent:_movement];
        
        _input = [[OGInputComponent alloc] init];
        _input.enabled = YES;
        [self addComponent:_input];
        
        OGPlayerEntityAppearState *appearState = [[OGPlayerEntityAppearState alloc] initWithPlayerEntity:self];
        OGPlayerEntityControlledState *controlledState = [[OGPlayerEntityControlledState alloc] initWithPlayerEntity:self];
        OGPlayerEntityAttackState *attackState = [[OGPlayerEntityAttackState alloc] initWithPlayerEntity:self];
        
        NSArray *states = @[appearState, controlledState, attackState];
        
        _intelligence = [[OGIntelligenceComponent alloc] initWithStates:states];
        [self addComponent:_intelligence];
        
        if ([OGPlayerEntity sOGPlayerEntityAnimations])
        {
            _animation = [[OGAnimationComponent alloc] initWithTextureSize:[OGPlayerEntity textureSize] animations:[OGPlayerEntity sOGPlayerEntityAnimations]];
            [_render.node addChild:_animation.spriteNode];
            [self addComponent:_animation];
        }
        else
        {
            return nil;
        }
        
        _orientation = [[OGOrientationComponent alloc] init];
        [self addComponent:_orientation];
        
        SKSpriteNode *targetSprite = (SKSpriteNode *) _render.node.children.firstObject;
        _messageComponent = [[OGMessageComponent alloc] initWithTarget:targetSprite minShowDistance:_playerConfiguration.messageShowDistance];
        [self addComponent:_messageComponent];
        
        _weaponComponent = [[OGWeaponComponent alloc] init];
        [self addComponent:_weaponComponent];
        
        _canTakeWeapon = YES;
    }
    
    return self;
}

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    if ([entity conformsToProtocol:@protocol(OGAttacking)] && self.canTakeWeapon)
    {
        OGRenderComponent *renderComponent = (OGRenderComponent *) [entity componentForClass:OGRenderComponent.self];
     
        [self dropCurrentWeaponAtPoint:renderComponent.node.position];
        
        if (renderComponent)
        {
            self.weaponComponent.weapon = (OGWeaponEntity *) entity;
            self.weaponComponent.weapon.owner = self;
            [self.inventory addItem:(id<OGInventoryItemProtocol>) entity];
            [renderComponent.node removeFromParent];
            
            SKAction *takeWeaponDelay = [SKAction waitForDuration:kOGPlayerEntityWeaponDropDelay];
            [self.render.node runAction:takeWeaponDelay completion:^()
            {
                self.canTakeWeapon = YES;
            }];
        }
    }
}

- (void)dropCurrentWeaponAtPoint:(CGPoint)point
{
    if (self.weaponComponent.weapon)
    {
        SKSpriteNode *weaponNode = (SKSpriteNode *) self.weaponComponent.weapon.render.node;
        
        CGPoint playerPosition = self.render.node.position;
        
        weaponNode.position = point;
        
        [self.render.node.scene addChild:weaponNode];
        
        CGVector dropVector = CGVectorMake(weaponNode.position.x - playerPosition.x,
                                           weaponNode.position.y - playerPosition.y);
        
        [weaponNode.physicsBody applyImpulse:dropVector];
        
        self.canTakeWeapon = NO;
        [self.inventory removeItem:self.weaponComponent.weapon];
        self.weaponComponent.weapon.owner = nil;
        self.weaponComponent.weapon = nil;
    }
}

@end
