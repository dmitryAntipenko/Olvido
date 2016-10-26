//
//  OGMovementControlComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMovementControlComponent.h"

CGFloat const kOGMovementControlComponentDefaultSpeedFactor = 1.0;


@implementation OGMovementControlComponent
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

- (void)stop
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
