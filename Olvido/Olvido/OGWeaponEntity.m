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
#import "OGBullet.h"
#import "OGWeaponComponent.h"
#import "OGMovementComponent.h"
#import "OGSoundComponent.h"

#import "OGZPositionEnum.m"
#import "OGInventoryItem.h"
#import "OGResourceLoadable.h"

CGFloat const OGWeaponEntityThrowingFactor = 80.0;

CGFloat const OGWeaponEntityDefaultAttackSpeed = 0.3;
CGFloat const OGWeaponEntityDefaultReloadSpeed = 1.0;

@interface OGWeaponEntity () <OGInventoryItem>

@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;
@property (nonatomic, strong) OGSoundComponent *soundComponent;
@property (nonatomic, weak, readonly) OGWeaponComponent *weaponComponent;

@property (nonatomic, assign) BOOL allowsAttacking;
@property (nonatomic, strong) NSTimer *attackTimer;
@property (nonatomic, strong) NSTimer *reloadTimer;

@property (nonatomic, assign, readwrite) CGFloat attackSpeed;
@property (nonatomic, assign, readwrite) CGFloat reloadSpeed;
@property (nonatomic, assign, readwrite) NSUInteger maxCharge;
@property (nonatomic, assign, readwrite) NSUInteger charge;

@end

@implementation OGWeaponEntity

- (instancetype)initWithSpriteNode:(SKSpriteNode *)sprite
                       attackSpeed:(CGFloat)attackSpeed
                       reloadSpeed:(CGFloat)reloadSpeed
                            charge:(NSUInteger)charge
{
    if (sprite)
    {
        self = [super init];

        if (self)
        {
            NSMutableArray *collisionColliders = [NSMutableArray arrayWithObjects:[OGColliderType obstacle], nil];
            [[OGColliderType definedCollisions] setObject:collisionColliders forKey:[OGColliderType weapon]];
            
            _renderComponent = [[OGRenderComponent alloc] init];
            _renderComponent.node = sprite;
            [self addComponent:_renderComponent];
            
            _physicsComponent = [[OGPhysicsComponent alloc] initWithPhysicsBody:sprite.physicsBody
                                                                   colliderType:[OGColliderType weapon]];
            [self addComponent:_physicsComponent];
            
            _allowsAttacking = YES;
            
            _attackSpeed = attackSpeed;
            _reloadSpeed = reloadSpeed;
            _charge = charge;
            _maxCharge = charge;
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

- (void)setOwner:(GKEntity *)owner
{
    _owner = owner;
    
    self.soundComponent.target = ((OGRenderComponent *) [_owner componentForClass:OGRenderComponent.self]).node;
}

#pragma mark - OGAttacking

- (void)attackWithVector:(CGVector)vector speed:(CGFloat)speed
{
    if (vector.dx != 0.0 && vector.dy != 0.0)
    {
        OGRenderComponent *ownerRenderComponent = (OGRenderComponent *) [self.owner componentForClass:[OGRenderComponent class]];
        
        if (ownerRenderComponent)
        {
            self.allowsAttacking = NO;
            
            self.attackTimer = [NSTimer scheduledTimerWithTimeInterval:speed repeats:NO block:^(NSTimer *timer)
            {
                if (self.charge-- <= 0)
                {
                    self.weaponComponent.shouldReload = YES;
                }
                else
                {
                    self.allowsAttacking = YES;
                }
                
                [timer invalidate];
                timer = nil;
            }];
        }
    }
}

- (void)reload
{
    self.allowsAttacking = NO;
    self.weaponComponent.shouldReload = NO;
    
    self.reloadTimer = [NSTimer scheduledTimerWithTimeInterval:self.reloadSpeed repeats:NO block:^(NSTimer *timer)
    {
        self.allowsAttacking = YES;
        self.charge = self.maxCharge;
        
        [timer invalidate];
        timer = nil;
    }];
}

- (BOOL)canAttack
{
    return self.allowsAttacking;
}

- (OGWeaponComponent *)weaponComponent
{
    return (OGWeaponComponent *) [self.owner componentForClass:[OGWeaponComponent class]];
}

#pragma mark - OGInventoryItem

- (void)wasTaken
{
    [self.renderComponent.node removeFromParent];
}

- (void)didThrown
{
    SKSpriteNode *weaponNode = (SKSpriteNode *) self.renderComponent.node;
    
    OGMovementComponent *ownerMovement = (OGMovementComponent *) [self.owner componentForClass:[OGMovementComponent class]];
    SKNode *ownerNode = ((OGRenderComponent *) [self.owner componentForClass:[OGRenderComponent class]]).node;
    
    weaponNode.position = ownerNode.position;
    
    [ownerNode.scene addChild:weaponNode];
    
    CGVector dropVector = CGVectorMake(-ownerMovement.displacementVector.dx * OGWeaponEntityThrowingFactor,
                                       -ownerMovement.displacementVector.dy * OGWeaponEntityThrowingFactor);
    
    [weaponNode.physicsBody applyImpulse:dropVector];
    
    self.owner = nil;
}

- (SKTexture *)texture
{
    return ((SKSpriteNode *) self.renderComponent.node).texture;
}

- (NSString *)identifier
{
    return self.renderComponent.node.name;
}

- (void)dealloc
{
    if (_attackTimer)
    {
        [_attackTimer invalidate];
    }
    
    if (_reloadTimer)
    {
        [_reloadTimer invalidate];
    }
}

@end
