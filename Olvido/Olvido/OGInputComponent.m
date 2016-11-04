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

- (void)didUpdateDestinationPoint:(CGPoint)destinationPoint
{
    InputState state;
    state.destinationPoint = destinationPoint;
    state.direction = self.state.direction;
    
    self.state = state;
}

- (void)didUpdateDirection:(CGPoint)direction
{
    InputState state;
    state.direction = direction;
    state.destinationPoint = self.state.destinationPoint;
    
    self.state = state;
    
    [self applyInputState];
}

- (void)applyInputState
{
    OGMovementComponent *movementComponent = (OGMovementComponent *) [self.entity componentForClass:[OGMovementComponent class]];
    
    movementComponent.destinationPoint = self.state.destinationPoint;
    movementComponent.direction = self.state.direction;
}

@end
