//
//  OGInputComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGInputComponent.h"
#import "OGMovementComponent.h"

typedef struct
{
    CGPoint destinationPoint;
    CGPoint direction;
    CGVector displacement;
} InputState;

@interface OGInputComponent ()

@property (nonatomic, assign) InputState state;

@end

@implementation OGInputComponent

- (void)setState:(InputState)state
{
    _state = state;
    
    if (self.isEnabled)
    {
        [self applyInputState];
    }
}

- (void)didUpdateDisplacement:(CGVector)displacement
{
    InputState state;
    state.destinationPoint = self.state.destinationPoint;
    state.direction = self.state.direction;
    state.displacement = displacement;
    
    self.state = state;
}

- (void)didUpdateDestinationPoint:(CGPoint)destinationPoint
{
    InputState state;
    state.destinationPoint = destinationPoint;
    state.direction = self.state.direction;
    state.displacement = self.state.displacement;
    
    self.state = state;
}

- (void)didUpdateDirection:(CGPoint)direction
{
    InputState state;
    state.direction = direction;
    state.destinationPoint = self.state.destinationPoint;
    state.displacement = self.state.displacement;
    
    self.state = state;
}

- (void)applyInputState
{
    OGMovementComponent *movementComponent = (OGMovementComponent *) [self.entity componentForClass:[OGMovementComponent class]];
    
    movementComponent.destinationPoint = self.state.destinationPoint;
    movementComponent.direction = self.state.direction;
    movementComponent.displacementVector = self.state.displacement;
}

@end
