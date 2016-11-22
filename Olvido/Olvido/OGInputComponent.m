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

#import "OGAnimationComponent.h"
#import "OGAnimation.h"

#import "OGConstants.h"

@interface OGInputComponent ()

@property (nonatomic, assign) CGVector displacement;
@property (nonatomic, assign) CGVector attackDisplacement;
@property (nonatomic, assign, getter=isPressed) BOOL pressed;

@end

@implementation OGInputComponent

- (void)didUpdateDisplacement:(CGVector)displacement
{
    self.displacement = displacement;
    [self applyInputState];
}

- (void)didUpdateAttackDisplacement:(CGVector)displacement
{
    self.attackDisplacement = displacement;
    [self applyInputState];
}

- (void)didPressed:(BOOL)pressed
{
    self.pressed = pressed;
    [self applyInputState];
}

- (void)applyInputState
{
    if (self.isEnabled)
    {
        OGMovementComponent *movementComponent = (OGMovementComponent *) [self.entity componentForClass:[OGMovementComponent class]];
        
        if (movementComponent)
        {
            movementComponent.displacementVector = self.displacement;
        }
        
        OGWeaponComponent *weaponComponent = (OGWeaponComponent *) [self.entity componentForClass:[OGWeaponComponent class]];
        
        if (weaponComponent)
        {
            weaponComponent.shouldAttack = self.pressed;
            weaponComponent.attackDirection = self.attackDisplacement;
        }
        
        OGAnimationComponent *animationComponent = (OGAnimationComponent *) [self.entity componentForClass:[OGAnimationComponent class]];
        
        if (animationComponent.currentAnimation.animationState == kOGAnimationStateWalkForward)
        {
            CGFloat k = hypot(self.displacement.dx, self.displacement.dy) / [OGConstants thumbStickNodeRadius];
            
            animationComponent.currentAnimation.timePerFrame = 0.1 * k;
            animationComponent.requestedAnimationState = kOGAnimationStateWalkForward;
        }
    }
}

@end
