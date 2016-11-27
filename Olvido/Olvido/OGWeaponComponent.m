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

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    if (self.weapon && self.shouldAttack && [self.weapon canAttack])
    {
        [self.weapon attackWithVector:self.attackDirection speed:self.attackSpeed];
    }
}

@end
