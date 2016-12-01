//
//  OGWeaponComponentRechargeState.m
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

NSString *const OGWeaponComponentRechargeSoundKey = @"weapon_recharge";

@interface OGWeaponComponentRechargeState ()

@property (nonatomic, strong) OGWeaponComponent *weaponComponent;
@property (nonatomic, weak) OGSoundComponent *soundComponent;

@property (nonatomic, assign) NSTimeInterval elapsedTime;

@end

@implementation OGWeaponComponentRechargeState

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
    
    [self.soundComponent playSoundOnce:OGWeaponComponentRechargeSoundKey];
    
    self.elapsedTime = 0.0;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    self.elapsedTime += seconds;
    
    if (self.elapsedTime >= self.weaponComponent.reloadSpeed)
    {
        self.weaponComponent.charge = self.weaponComponent.maxCharge;
        if ([self.stateMachine canEnterState:[OGWeaponComponentIdleState class]])
        {
            [self.stateMachine enterState:[OGWeaponComponentIdleState class]];
        }
    }
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [OGWeaponComponentIdleState class]
    || stateClass == [OGWeaponComponentAttackState class];
}

- (OGSoundComponent *)soundComponent
{
    if (!_soundComponent)
    {
        _soundComponent = (OGSoundComponent *) [self.weaponComponent.weapon componentForClass:[OGSoundComponent class]];
    }
    
    return _soundComponent;
}

@end
