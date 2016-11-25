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

#import "OGConstants.h"

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
    
    self.animationComponent.requestedAnimationState = kOGConstantsIdle;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [OGPlayerEntityAttackState class];
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


@end
