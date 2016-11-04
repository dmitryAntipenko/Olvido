//
//  OGTouchControlInputNode.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTouchControlInputNode.h"

@implementation OGTouchControlInputNode

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    CGPoint displacement;
    
    if (location.x < self.size.width / 2.0)
    {
        displacement = CGPointMake(-1.0, 0.0);
    }
    else
    {
        displacement = CGPointMake(1.0, 0.0);
    }
    
    [self.inputSourceDelegate didUpdateDestinationPoint:location];
}

- (BOOL)isUserInteractionEnabled
{
    return YES;
}

@end
