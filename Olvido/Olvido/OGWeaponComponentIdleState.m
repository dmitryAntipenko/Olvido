//
//  OGWeaponComponentIdleState.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGWeaponComponentIdleState.h"
#import "OGWeaponComponentAttackState.h"

#import "OGWeaponComponent.h"

@interface OGWeaponComponentIdleState ()

@property (nonatomic, strong) OGWeaponComponent *weaponComponent;

@end

@implementation OGWeaponComponentIdleState

- (instancetype)initWithWeaponComponent:(OGWeaponComponent *)weaponComponent
{
    self = [super init];
    
    if (self)
    {
        _weaponComponent = weaponComponent;
    }
    
    return self;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    if (self.weaponComponent.shouldAttack
        && self.weaponComponent.attackDirection.dx != 0.0
        && self.weaponComponent.attackDirection.dy != 0.0
        && [self.stateMachine canEnterState:[OGWeaponComponentAttackState class]])
    {
        [self.stateMachine enterState:[OGWeaponComponentAttackState class]];
    }
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [OGWeaponComponentAttackState class];
}

@end
