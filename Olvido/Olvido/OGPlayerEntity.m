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
#import "OGInventoryItem.h"
#import "OGInventoryComponent.h"
#import "OGPlayerEntity+OGPlayerEntityResources.h"

#import "OGColliderType.h"

#import "OGPlayerConfiguration.h"
#import "OGAnimationState.h"

#import "OGPlayerEntityAppearState.h"
#import "OGplayerEntityControlledState.h"
#import "OGplayerEntityAttackState.h"

CGFloat const kOGPlayerEntityWeaponDropDelay = 1.0;

@interface OGPlayerEntity ()

@property (nonatomic, strong) NSTimer *bulletSpawnTimer;
@property (nonatomic, assign) BOOL canTakeWeapon;

@end

@implementation OGPlayerEntity

- (instancetype)initWithConfiguration:(OGPlayerConfiguration *)configuration
{
    self = [super init];
    
    if (self)
    {
        _inventoryComponent = [OGInventoryComponent inventoryComponent];
        [self addComponent:_inventoryComponent];
        
        _render = [[OGRenderComponent alloc] init];
        [self addComponent:_render];
        
        _physics = [[OGPhysicsComponent alloc] initWithPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:configuration.physicsBodyRadius]
                                                      colliderType:[OGColliderType player]];
        [self addComponent:_physics];
        
        _render.node.physicsBody = _physics.physicsBody;
        _render.node.physicsBody.allowsRotation = NO;
        
        _health = [[OGHealthComponent alloc] init];
        _health.maxHealth = configuration.maxHealth;
        _health.currentHealth = configuration.currentHealth;
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
            _animation.spriteNode.anchorPoint = CGPointMake(0.5, 0.2);
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
        _messageComponent = [[OGMessageComponent alloc] initWithTarget:targetSprite minShowDistance:configuration.messageShowDistance];
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
        OGWeaponEntity *weaponEntity = (OGWeaponEntity *)entity;
        
        OGRenderComponent *renderComponent = (OGRenderComponent *) [entity componentForClass:OGRenderComponent.self];
     
        [self.inventoryComponent removeItem:self.weaponComponent.weapon];
        self.canTakeWeapon = NO;
        
        if (renderComponent)
        {
            self.weaponComponent.weapon = (OGWeaponEntity *) entity;
            self.weaponComponent.weapon.owner = self;
            
            [renderComponent.node removeFromParent];
            
            self.bulletSpawnTimer = [NSTimer scheduledTimerWithTimeInterval:kOGPlayerEntityWeaponDropDelay repeats:NO block:^(NSTimer *timer)
            {
                self.canTakeWeapon = YES;
                [timer invalidate];
                timer = nil;
            }];
        }
        
        [self.inventoryComponent addItem:weaponEntity];
    }
}

@end
