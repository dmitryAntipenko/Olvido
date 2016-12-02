//
//  OGWeaponComponentAttackState.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGWeaponComponentAttackState.h"
#import "OGWeaponComponentIdleState.h"
#import "OGWeaponComponentRechargeState.h"

#import "OGWeaponComponent.h"
#import "OGSoundComponent.h"

NSString *const OGWeaponComponentAttackSoundKey = @"weapon_attack";

@interface OGWeaponComponentAttackState ()

@property (nonatomic, strong) OGWeaponComponent *weaponComponent;
@property (nonatomic, weak) OGSoundComponent *soundComponent;

@property (nonatomic, assign) NSTimeInterval elapsedTime;

@end

@implementation OGWeaponComponentAttackState

- (instancetype)initWithWeaponComponent:(OGWeaponComponent *)weaponComponent
{
    self = [super init];
    
    if (self)
    {
        _weaponComponent = weaponComponent;
    }
    
    return self;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    [self attack];
}

- (void)attack
{
    [self.weaponComponent.weapon attackWithVector:self.weaponComponent.attackDirection];
    
    [self.soundComponent playSoundOnce:OGWeaponComponentAttackSoundKey];
    
    self.elapsedTime = 0.0;
    self.weaponComponent.charge--;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    self.elapsedTime += seconds;
    
    if (self.elapsedTime >= self.weaponComponent.attackSpeed)
    {
        [self attack];
    }
    
    if (self.weaponComponent.charge <= 0.0)
    {
        if ([self.stateMachine canEnterState:[OGWeaponComponentRechargeState class]])
        {
            [self.stateMachine enterState:[OGWeaponComponentRechargeState class]];
        }
    }
    else if (!self.weaponComponent.shouldAttack)
    {
        if ([self.stateMachine canEnterState:[OGWeaponComponentIdleState class]])
        {
            [self.stateMachine enterState:[OGWeaponComponentIdleState class]];
        }
    }
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [OGWeaponComponentIdleState class]
    || stateClass == [OGWeaponComponentRechargeState class];
}

- (OGSoundComponent *)soundComponent
{
    return _soundComponent = (OGSoundComponent *) [self.weaponComponent.weapon componentForClass:[OGSoundComponent class]];
}

@end
