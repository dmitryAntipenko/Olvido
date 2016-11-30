//
//  OGWeaponComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/12/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGWeaponComponent.h"
#import "OGRenderComponent.h"
#import "OGAnimationComponent.h"

#import "OGWeaponComponentIdleState.h"
#import "OGWeaponComponentAttackState.h"
#import "OGWeaponComponentRechargeState.h"

#import "OGWeaponEntity.h"

CGFloat const OGWeaponComponentDefaultAttackSpeed = 1.0;

@interface OGWeaponComponent ()

@property (nonatomic, strong) GKStateMachine *weaponStateMachine;

@end

@implementation OGWeaponComponent

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _attackSpeed = OGWeaponComponentDefaultAttackSpeed;
        
        OGWeaponComponentIdleState *idleState = [[OGWeaponComponentIdleState alloc] initWithWeaponComponent:self];
        OGWeaponComponentAttackState *attackState = [[OGWeaponComponentAttackState alloc] initWithWeaponComponent:self];
        OGWeaponComponentRechargeState *rechargeState = [[OGWeaponComponentRechargeState alloc] initWithWeaponComponent:self];
        
        _weaponStateMachine = [GKStateMachine stateMachineWithStates:@[idleState, attackState, rechargeState]];
    }
    
    return self;
}

- (void)didAddToEntity
{
    [super didAddToEntity];
    
    [self.weaponStateMachine enterState:[OGWeaponComponentIdleState class]];
}

#pragma mark - Getters & Setters

- (void)setWeapon:(OGWeaponEntity *)weapon
{
    _weapon = weapon;
    
    self.attackSpeed = weapon.attackSpeed;
    self.charge = weapon.charge;
    self.maxCharge = weapon.maxCharge;
}

- (void)setCharge:(NSUInteger)charge
{
    _charge = charge;
    
    self.weapon.charge = _charge;
}

- (void)setMaxCharge:(NSUInteger)maxCharge
{
    _maxCharge = maxCharge;
    
    self.weapon.maxCharge = _maxCharge;
}

- (CGFloat)reloadSpeed
{
    return self.weapon.reloadSpeed;
}

#pragma mark - Update

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    [self.weaponStateMachine updateWithDeltaTime:seconds];
}

@end
