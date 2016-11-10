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
    
    self.animationComponent.requestedAnimationState = kOGAnimationStateIdle;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == OGPlayerEntityAttackState.self;
}

- (OGAnimationComponent *)animationComponent
{
    if (!_animationComponent)
    {
        _animationComponent = (OGAnimationComponent *) [self.playerEntity componentForClass:OGAnimationComponent.self];
    }
    
    return _animationComponent;
}

- (OGMovementComponent *)movementComponent
{
    if (!_movementComponent)
    {
        _movementComponent = (OGMovementComponent *) [self.playerEntity componentForClass:OGAnimationComponent.self];
    }
    
    return _movementComponent;
}

- (OGInputComponent *)inputComponent
{
    if (!_inputComponent)
    {
        _inputComponent = (OGInputComponent *) [self.playerEntity componentForClass:OGInputComponent.self];
    }
    
    return _inputComponent;
}


@end
