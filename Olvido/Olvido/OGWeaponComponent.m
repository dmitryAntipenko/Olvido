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

#import "OGWeaponEntity.h"

CGFloat const OGWeaponComponentDefaultAttackSpeed = 1.0;

@implementation OGWeaponComponent

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _attackSpeed = OGWeaponComponentDefaultAttackSpeed;
    }
    
    return self;
}

- (void)setWeapon:(OGWeaponEntity *)weapon
{
    _weapon = weapon;
    
    self.attackSpeed = weapon.attackSpeed;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    if (self.weapon)
    {
        if (self.shouldReload)
        {
            [self.weapon reload];
        }
        else if (self.shouldAttack && [self.weapon canAttack])
        {
            [self.weapon attackWithVector:self.attackDirection speed:self.attackSpeed];
        }
    }
}

@end
