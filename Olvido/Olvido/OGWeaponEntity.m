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
#import "OGWeaponComponentObserving.h"

#import "OGZPositionEnum.m"

CGFloat const OGWeaponEntityThrowingFactor = 80.0;

CGFloat const OGWeaponEntityDefaultAttackSpeed = 0.3;
CGFloat const OGWeaponEntityDefaultReloadSpeed = 1.0;

@interface OGWeaponEntity ()

@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;
@property (nonatomic, weak, readonly) OGWeaponComponent *weaponComponent;

@property (nonatomic, assign) BOOL allowsAttacking;

@property (nonatomic, assign, readwrite) CGFloat attackSpeed;
@property (nonatomic, assign, readwrite) CGFloat reloadSpeed;

@end

@implementation OGWeaponEntity

#pragma mark - Initializing

- (instancetype)initWithSpriteNode:(SKSpriteNode *)sprite
                       attackSpeed:(CGFloat)attackSpeed
                       reloadSpeed:(CGFloat)reloadSpeed
                            charge:(NSInteger)charge
                         maxCharge:(NSInteger)maxCharge
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
            _maxCharge = maxCharge;
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

#pragma mark - Getters & Setters

- (void)setCharge:(NSInteger)charge
{
    _charge = charge;
    
    [self.weaponComponent.weaponObserver weaponDidUpdateKey:@"Charge" withValue:@(_charge)];
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

@end
