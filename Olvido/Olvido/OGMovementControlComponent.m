//
//  OGMovementControlComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMovementControlComponent.h"

CGFloat const kOGMovementControlComponentDefaultSpeedFactor = 1.0;
CGFloat const kOGTapMovementControlComponentDefaultSpeed = 500;


@implementation OGMovementControlComponent

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _defaultSpeed = kOGTapMovementControlComponentDefaultSpeed;
    }
    
    return self;
}

#pragma mark subclasses should implement

- (void)touchBeganAtPoint:(CGPoint)point
{
    
}

- (void)touchEndedAtPoint:(CGPoint)point
{
    
}

- (void)touchMovedToPoint:(CGPoint)point
{
    
}

- (void)pause
{
    
}

- (void)resume
{
    
}

- (void)didChangeDirection
{
    
}

- (void)didAddToEntity
{
    _visualComponent = (OGVisualComponent *)[self.entity componentForClass:[OGVisualComponent class]];
}

- (void)dealloc
{
    [super dealloc];
}

@end
