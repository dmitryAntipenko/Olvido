//
//  OGInputComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGInputComponent.h"
#import "OGMovementComponent.h"
#import "OGWeaponComponent.h"

@interface OGInputComponent ()

@property (nonatomic, assign) CGVector displacement;
@property (nonatomic, assign, getter=isPressed) BOOL pressed;

@end

@implementation OGInputComponent

- (void)didUpdateDisplacement:(CGVector)displacement
{
    self.displacement = displacement;
    
    if (self.isEnabled)
    {
        [self applyInputState];
    }
}

- (void)didPressed:(BOOL)pressed
{
    self.pressed = pressed;
    
    if (self.isEnabled)
    {
        [self applyInputState];
    }
}

- (void)applyInputState
{
    OGMovementComponent *movementComponent = (OGMovementComponent *) [self.entity componentForClass:OGMovementComponent.self];
    
    if (movementComponent)
    {
        movementComponent.displacementVector = self.displacement;
    }
    
    OGWeaponComponent *weaponComponent = (OGWeaponComponent *) [self.entity componentForClass:OGWeaponComponent.self];
    
    if (weaponComponent)
    {
        weaponComponent.shouldAttack = self.pressed;
        weaponComponent.attackDirection = self.displacement;
    }
}

@end
