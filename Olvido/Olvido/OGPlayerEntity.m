//
//  OGPlayerEntity.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerEntity.h"
#import "OGPlayerEntity+OGPlayerEntityResources.h"
#import "OGPlayerConfiguration.h"
#import "OGTextureConfiguration.h"

#import "OGRenderComponent.h"
#import "OGHealthComponent.h"
#import "OGIntelligenceComponent.h"
#import "OGInputComponent.h"
#import "OGMovementComponent.h"
#import "OGAnimationComponent.h"
#import "OGAnimation.h"
#import "OGPhysicsComponent.h"
#import "OGMessageComponent.h"
#import "OGOrientationComponent.h"
#import "OGWeaponComponent.h"
#import "OGInventoryItem.h"
#import "OGInventoryComponent.h"
#import "OGShadowComponent.h"
#import "OGHealthBarComponent.h"
#import "OGFlashlightComponent.h"

#import "OGSceneItemEntity.h"

#import "OGColliderType.h"
#import "OGZPositionEnum.h"

#import "OGPlayerEntityAppearState.h"
#import "OGPlayerEntityControlledState.h"
#import "OGPlayerEntityAttackState.h"
#import "OGPlayerEntityDieState.h"

#import "OGContactNotifiableType.h"
#import "OGHealthComponentDelegate.h"

#import "OGTextureAtlasesManager.h"

static OGTextureConfiguration *sOGPlayerEntityDefaultTextureConfiguration = nil;

CGFloat const OGPlayerEntityWeaponDropDelay = 1.0;
CGFloat const OGPlayerEntityShadowYOffset = -40.0;

NSString *const OGPlayerEntityShadowTextureName = @"PlayerShadow";
NSString *OGPlayerEntityUnitName = @"Player";

@interface OGPlayerEntity () <OGContactNotifiableType, GKAgentDelegate, OGHealthComponentDelegate, OGSceneItemsDelegate>

@property (nonatomic, strong) OGShadowComponent         *shadowComponent;
@property (nonatomic, strong) OGInventoryComponent      *inventoryComponent;
@property (nonatomic, strong) OGRenderComponent         *renderComponent;
@property (nonatomic, strong) OGPhysicsComponent        *physicsComponent;
@property (nonatomic, strong) OGInputComponent          *inputComponent;
@property (nonatomic, strong) OGIntelligenceComponent   *intelligenceComponent;
@property (nonatomic, strong) OGHealthComponent         *healthComponent;
@property (nonatomic, strong) OGAnimationComponent      *animationComponent;
@property (nonatomic, strong) OGMovementComponent       *movementComponent;
@property (nonatomic, strong) OGMessageComponent        *messageComponent;
@property (nonatomic, strong) OGOrientationComponent    *orientationComponent;
@property (nonatomic, strong) OGWeaponComponent         *weaponComponent;
@property (nonatomic, strong) OGHealthBarComponent      *healthBarComponent;
@property (nonatomic, strong) OGFlashlightComponent     *flashlightComponent;
@property (nonatomic, strong, readwrite) GKAgent2D                 *agent;

@property (nonatomic, strong) NSTimer *weaponTakeDelayTimer;
@property (nonatomic, assign) BOOL canTakeWeapon;

@property (nonatomic, assign) BOOL shouldDie;
@end

@implementation OGPlayerEntity

- (instancetype)initWithConfiguration:(OGPlayerConfiguration *)configuration    
{
    self = [super init];
    
    if (self)
    {
        _shouldDie = NO;
        _agent = [[GKAgent2D alloc] init];
        _agent.radius = configuration.physicsBodyRadius;
        [self addComponent:_agent];
        
        _inventoryComponent = [OGInventoryComponent inventoryComponent];
        [self addComponent:_inventoryComponent];
        
        _renderComponent = [[OGRenderComponent alloc] init];
        [self addComponent:_renderComponent];
        
        _physicsComponent = [[OGPhysicsComponent alloc] initWithPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:configuration.physicsBodyRadius]
                                                               colliderType:[OGColliderType player]];
        _physicsComponent.physicsBody.mass = 5.0;
        [self addComponent:_physicsComponent];
        
        _renderComponent.node.physicsBody = _physicsComponent.physicsBody;
        _renderComponent.node.physicsBody.allowsRotation = NO;
        
        SKTexture *shadowTexture = [SKTexture textureWithImageNamed:OGPlayerEntityShadowTextureName];
        _shadowComponent = [[OGShadowComponent alloc] initWithTexture:shadowTexture offset:-configuration.physicsBodyRadius];    
        [self addComponent:_shadowComponent];
        
        [_renderComponent.node addChild:_shadowComponent.node];
        
        _healthComponent = [[OGHealthComponent alloc] init];
        _healthComponent.maxHealth = configuration.maxHealth;
        _healthComponent.currentHealth = configuration.currentHealth;
        _healthComponent.delegate = self;
        [self addComponent:_healthComponent];
        
        _movementComponent = [[OGMovementComponent alloc] init];
        [self addComponent:_movementComponent];
        
        _inputComponent = [[OGInputComponent alloc] init];
        _inputComponent.enabled = YES;
        [self addComponent:_inputComponent];
        
        OGPlayerEntityAppearState *appearState = [[OGPlayerEntityAppearState alloc] initWithPlayerEntity:self];
        OGPlayerEntityControlledState *controlledState = [[OGPlayerEntityControlledState alloc] initWithPlayerEntity:self];
        OGPlayerEntityAttackState *attackState = [[OGPlayerEntityAttackState alloc] initWithPlayerEntity:self];
        OGPlayerEntityDieState *dieState = [[OGPlayerEntityDieState alloc] initWithPlayerEntity:self];
        
        NSArray *states = @[appearState, controlledState, attackState, dieState];
        
        _intelligenceComponent = [[OGIntelligenceComponent alloc] initWithStates:states];
        [self addComponent:_intelligenceComponent];
        
        NSMutableDictionary *animations = [NSMutableDictionary dictionary];
        
        for (OGTextureConfiguration *textureConfiguration in configuration.textures)
        {
            OGAnimation *animation = [OGAnimation animationWithTextureConfiguration:textureConfiguration
                                                               defaultConfiguration:sOGPlayerEntityDefaultTextureConfiguration
                                                                           unitName:OGPlayerEntityUnitName];
            
            animations[animation.stateName] = animation;
        }
        
        _animationComponent = [[OGAnimationComponent alloc] initWithAnimations:animations];
        [self.renderComponent.node addChild:_animationComponent.spriteNode];
        _animationComponent.spriteNode.anchorPoint = CGPointMake(0.5, 0.0);
        _animationComponent.spriteNode.position = CGPointMake(0.0, -configuration.physicsBodyRadius);
        [self addComponent:_animationComponent];
        
        _orientationComponent = [[OGOrientationComponent alloc] init];
        [self addComponent:_orientationComponent];
        
        SKSpriteNode *targetSprite = (SKSpriteNode *) _renderComponent.node;
        SKLabelNode *messageLabelNode = [SKLabelNode node];
        messageLabelNode.zPosition = OGZPositionCategoryForeground;
        _messageComponent = [[OGMessageComponent alloc] initWithTarget:targetSprite
                                                       minShowDistance:configuration.messageShowDistance
                                                             labelNode:messageLabelNode];
        [self addComponent:_messageComponent];
        
        _weaponComponent = [[OGWeaponComponent alloc] init];
        [self addComponent:_weaponComponent];
        
        _healthBarComponent = [OGHealthBarComponent healthBarComponent];
        [self addComponent:_healthBarComponent];
        
        _flashlightComponent = [[OGFlashlightComponent alloc] init];        
        [self addComponent:_flashlightComponent];
        
        _canTakeWeapon = YES;
    }
    
    return self;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    if (self.shouldDie)
    {
        if ([self.intelligenceComponent.stateMachine canEnterState:[OGPlayerEntityDieState class]])
        {
            [self.intelligenceComponent.stateMachine enterState:[OGPlayerEntityDieState class]];
        }
        
        self.shouldDie = NO;
    }
}

#pragma mark - OGSceneItemsDelegate 

- (void)itemWillBeTaken:(OGSceneItemEntity *)entity
{
    if ([entity conformsToProtocol:@protocol(OGInventoryItem)])
    {
        [self.delegate removeEntity:entity];
        
        [self.inventoryComponent addItem:(id<OGInventoryItem>) entity];
        
        if ([entity conformsToProtocol:@protocol(OGAttacking)])
        {
            OGWeaponEntity *weaponEntity = (OGWeaponEntity *) entity;            
            weaponEntity.owner = self;
            self.weaponComponent.weapon = weaponEntity;
        }
    }
}

#pragma mark - OGContactNotifiableType protocol

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    if ([entity isKindOfClass:[OGSceneItemEntity class]])
    {
        [self itemWillBeTaken:(OGSceneItemEntity *) entity];
    }
}

- (void)contactWithEntityDidEnd:(GKEntity *)entity
{
    
}

#pragma mark - dealloc

- (void)dealloc
{
    if (_weaponTakeDelayTimer)
    {
        [_weaponTakeDelayTimer invalidate];
        _weaponTakeDelayTimer = nil;
    }
}

#pragma mark - Update

- (void)updateAgentPositionToMatchNodePosition
{
    CGPoint position = self.renderComponent.node.position;
    
    self.agent.position = (vector_float2){position.x, position.y};
}

#pragma mark - OGHealthComponentDelegate protocol

- (void)healthDidChange
{
    [self.healthBarComponent redrawBarNode];
}

- (void)entityWillDie
{
    self.shouldDie = YES;
}

- (void)dealDamageToEntity:(NSInteger)damage
{
    if (self.healthComponent)
    {
        [self.healthComponent dealDamage:damage];
    }
}

- (void)restoreEntityHealth:(NSInteger)health
{
    if (self.healthComponent)
    {
        [self.healthComponent restoreHealth:health];
    }
}

#pragma mark - didDie

- (void)entityDidDie
{
    [self.delegate removeEntity:self];
    [self.delegate playerDidDie];
}

@end
