//
//  OGPlayerEntityControlledState.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/9/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerEntityControlledState.h"
#import "OGPlayerEntity.h"
#import "OGPlayerEntityAttackState.h"
#import "OGPlayerEntityDieState.h"

#import "OGAnimationComponent.h"
#import "OGMovementComponent.h"
#import "OGInputComponent.h"
#import "OGOrientationComponent.h"
#import "OGWeaponComponent.h"

#import "OGConstants.h"

@interface OGPlayerEntityControlledState ()

@property (nonatomic, weak) OGPlayerEntity *playerEntity;

@property (nonatomic, strong) OGAnimationComponent *animationComponent;
@property (nonatomic, strong) OGMovementComponent *movementComponent;
@property (nonatomic, strong) OGInputComponent *inputComponent;
@property (nonatomic, strong) OGOrientationComponent *orientationComponent;
@property (nonatomic, strong) OGWeaponComponent *weaponComponent;

@end

@implementation OGPlayerEntityControlledState

- (instancetype)initWithPlayerEntity:(OGPlayerEntity *)playerEntity
{
    self = [self init];
    
    if (self)
    {
        _playerEntity = playerEntity;
    }
    
    return self;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    [self.inputComponent setEnabled:YES];
    
    self.animationComponent.requestedAnimationState = OGConstantsIdle;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    CGVector displacementVector = self.movementComponent.displacementVector;
    
    if (self.weaponComponent.weapon)
    {
        CGVector attackVector = self.weaponComponent.attackDirection;
        
        if ((attackVector.dx != 0 || attackVector.dy != 0)
            && (displacementVector.dx != 0 || displacementVector.dy != 0))
        {
            self.animationComponent.playBackwards = YES;
            [self changeAnimationStateWithVector:attackVector];
        }
        else
        {
            [self changeAnimationStateWithVector:displacementVector];
        }
    }
    else
    {
        [self changeAnimationStateWithVector:displacementVector];
    }
}

- (void)changeAnimationStateWithVector:(CGVector)vector
{
    if (vector.dx != 0 || vector.dy != 0)
    {
        self.orientationComponent.currentOrientation = [OGOrientationComponent orientationWithVectorX:vector.dx];
        self.animationComponent.requestedAnimationState = OGConstantsWalk;
    }
    else
    {
        self.animationComponent.requestedAnimationState = OGConstantsIdle;
    }
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [OGPlayerEntityAttackState class] || stateClass == [OGPlayerEntityDieState class];
}

- (void)willExitWithNextState:(GKState *)nextState
{
    [super willExitWithNextState:nextState];
    
    [self.inputComponent setEnabled:NO];
    
    OGMovementComponent *movementComponent = self.movementComponent;
    
    movementComponent.displacementVector = CGVectorMake(0, 0);
}

- (OGAnimationComponent *)animationComponent
{
    if (!_animationComponent)
    {
        _animationComponent = (OGAnimationComponent *) [self.playerEntity componentForClass:[OGAnimationComponent class]];
    }
    
    return _animationComponent;
}

- (OGMovementComponent *)movementComponent
{
    if (!_movementComponent)
    {
        _movementComponent = (OGMovementComponent *) [self.playerEntity componentForClass:[OGMovementComponent class]];
    }
    
    return _movementComponent;
}

- (OGInputComponent *)inputComponent
{
    if (!_inputComponent)
    {
        _inputComponent = (OGInputComponent *) [self.playerEntity componentForClass:[OGInputComponent class]];
    }
    
    return _inputComponent;
}

- (OGOrientationComponent *)orientationComponent
{
    if (!_orientationComponent)
    {
        _orientationComponent = (OGOrientationComponent *) [self.playerEntity componentForClass:[OGOrientationComponent class]];
    }
    
    return _orientationComponent;
}

- (OGWeaponComponent *)weaponComponent
{
    if (!_weaponComponent)
    {
        _weaponComponent = (OGWeaponComponent *) [self.playerEntity componentForClass:[OGWeaponComponent class]];
    }
    
    return _weaponComponent;
}

@end
