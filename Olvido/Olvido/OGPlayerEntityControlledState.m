//
//  OGPlayerEntityControlledState.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/9/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerEntityControlledState.h"
#import "OGAnimationComponent.h"
#import "OGMovementComponent.h"
#import "OGInputComponent.h"

#import "OGPlayerEntity.h"

#import "OGPlayerEntityAttackState.h"

@interface OGPlayerEntityControlledState ()

@property (nonatomic, weak) OGPlayerEntity *playerEntity;

@property (nonatomic, strong) OGAnimationComponent *animationComponent;
@property (nonatomic, strong) OGMovementComponent *movementComponent;
@property (nonatomic, strong) OGInputComponent *inputComponent;

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
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    self.animationComponent.requestedAnimationState = kOGAnimationStateIdle;
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == OGPlayerEntityAttackState.self;
}

- (OGAnimationComponent *)animationComponent
{
    if (!_animationComponent)
    {
        OGAnimationComponent *animationComponent = (OGAnimationComponent *) [self.playerEntity componentForClass:OGAnimationComponent.self];
        if (animationComponent)
        {
            _animationComponent = animationComponent;
        }
        else
        {
            [NSException raise:@"Exception.OGPlayerEntityControlledState" format:@"A OGPlayerEntityControlledState's entity must have an AnimationComponent."];
        }
    }
    
    return _animationComponent;
}

- (OGMovementComponent *)movementComponent
{
    if (!_movementComponent)
    {
        OGMovementComponent *movementComponent = (OGMovementComponent *) [self.playerEntity componentForClass:OGAnimationComponent.self];
        if (movementComponent)
        {
            _movementComponent = movementComponent;
        }
        else
        {
            [NSException raise:@"Exception.OGPlayerEntityControlledState" format:@"A OGPlayerEntityControlledState's entity must have an MovementComponent."];
        }
    }
    
    return _movementComponent;
}

- (OGInputComponent *)inputComponent
{
    if (!_animationComponent)
    {
        OGInputComponent *inputComponent = (OGInputComponent *) [self.playerEntity componentForClass:OGInputComponent.self];
        if (inputComponent)
        {
            _inputComponent = inputComponent;
        }
        else
        {
            [NSException raise:@"Exception.OGPlayerEntityControlledState" format:@"A OGPlayerEntityControlledState's entity must have an InputComponent."];
        }
    }
    
    return _inputComponent;
}


@end
