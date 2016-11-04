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
    CGPoint direction;
    
    if (location.x < 0.0)
    {
        direction = CGPointMake(-1.0, 0.0);
    }
    else
    {
        direction = CGPointMake(1.0, 0.0);
    }
    
    [self.inputSourceDelegate didUpdateDirection:direction];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint direction = CGPointZero;
    [self.inputSourceDelegate didUpdateDirection:direction];
}

- (BOOL)isUserInteractionEnabled
{
    return YES;
}

@end
