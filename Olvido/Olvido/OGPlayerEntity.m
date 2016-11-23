//
//  OGPlayerEntity.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerEntity.h"
#import "OGShadowComponent.h"
#import "OGPlayerEntity+OGPlayerEntityResources.h"
#import "OGPlayerConfiguration.h"
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

#import "OGColliderType.h"
#import "OGZPositionEnum.m"

#import "OGAnimationState.h"
#import "OGPlayerEntityAppearState.h"
#import "OGplayerEntityControlledState.h"
#import "OGplayerEntityAttackState.h"

#import "OGContactNotifiableType.h"
#import "OGHealthComponentDelegate.h"

CGFloat const kOGPlayerEntityWeaponDropDelay = 1.0;
NSString *const kOGPlayerEntityShadowTextureName = @"PlayerShadow";
CGFloat const kOGPlayerEntityShadowYOffset = -40.0;

@interface OGPlayerEntity () <OGContactNotifiableType, GKAgentDelegate, OGHealthComponentDelegate>

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
@property (nonatomic, strong) GKAgent2D                 *agent;

@property (nonatomic, strong) NSTimer *weaponTakeDelayTimer;
@property (nonatomic, assign) BOOL canTakeWeapon;

@end

@implementation OGPlayerEntity

- (instancetype)initWithConfiguration:(OGPlayerConfiguration *)configuration
{
    self = [super init];
    
    if (self)
    {
        _agent = [[GKAgent2D alloc] init];
        _agent.radius = configuration.physicsBodyRadius;
        [self addComponent:_agent];
        
        _inventoryComponent = [OGInventoryComponent inventoryComponent];
        [self addComponent:_inventoryComponent];
        
        _renderComponent = [[OGRenderComponent alloc] init];
        [self addComponent:_renderComponent];
        
        _physicsComponent = [[OGPhysicsComponent alloc] initWithPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:configuration.physicsBodyRadius]
                                                      colliderType:[OGColliderType player]];
        _physicsComponent.physicsBody.mass = 100.0;
        [self addComponent:_physicsComponent];
        
        _renderComponent.node.physicsBody = _physicsComponent.physicsBody;
        _renderComponent.node.physicsBody.allowsRotation = NO;
        
        SKTexture *shadowTexture = [SKTexture textureWithImageNamed:kOGPlayerEntityShadowTextureName];
        CGPoint shadowOffset = CGPointMake(0.0, kOGPlayerEntityShadowYOffset);
        _shadowComponent = [[OGShadowComponent alloc] initWithTexture:shadowTexture offset:shadowOffset];
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
        
        NSArray *states = @[appearState, controlledState, attackState];
        
        _intelligenceComponent = [[OGIntelligenceComponent alloc] initWithStates:states];
        [self addComponent:_intelligenceComponent];
        
        if ([OGPlayerEntity sOGPlayerEntityAnimations])
        {
            _animationComponent = [[OGAnimationComponent alloc] initWithAnimations:[OGPlayerEntity sOGPlayerEntityAnimations]];
            
            [_renderComponent.node addChild:_animationComponent.spriteNode];
            [self addComponent:_animationComponent];
        }
        else
        {
            return nil;
        }
        
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
        
        _canTakeWeapon = YES;
    }
    
    return self;
}

#pragma mark - OGContactNotifiableType protocol
- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    if ([entity conformsToProtocol:@protocol(OGAttacking)] && self.canTakeWeapon)
    {
        [self.inventoryComponent removeItem:(id<OGInventoryItem>) self.weaponComponent.weapon];
        self.canTakeWeapon = NO;
        
        self.weaponComponent.weapon = (OGWeaponEntity *) entity;
        self.weaponComponent.weapon.owner = self;
        
        self.weaponTakeDelayTimer = [NSTimer scheduledTimerWithTimeInterval:kOGPlayerEntityWeaponDropDelay repeats:NO block:^(NSTimer *timer)
        {
            self.canTakeWeapon = YES;
            [timer invalidate];
            timer = nil;
        }];
        
        [self.inventoryComponent addItem:(id<OGInventoryItem>) entity];
        [self.messageComponent showMessage:@"Shotgun!" duration:3.0 shouldOverlay:YES];
    }
    
    if ([entity conformsToProtocol:@protocol(OGInventoryItem)]
        && ![entity conformsToProtocol:@protocol(OGAttacking)])
    {
        OGRenderComponent *renderComponent = (OGRenderComponent *) [entity componentForClass:[OGRenderComponent class]];
        [renderComponent.node removeFromParent];
        [self.inventoryComponent addItem:(id<OGInventoryItem>) entity];
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

- (void)updateAgentPositionToMatchNodePosition
{
    CGPoint position = self.renderComponent.node.position;
    
    self.agent.position = (vector_float2){position.x, position.y};
}

#pragma mark - OGHealthComponentDelegate protoc
- (void)entityWillDie
{
    
}

- (void)dealDamage:(NSInteger)damage
{
    if (self.healthComponent)
    {
        [self.healthComponent dealDamage:damage];
    }
}

@end
