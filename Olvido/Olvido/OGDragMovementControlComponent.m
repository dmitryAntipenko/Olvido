//
//  OGTrackControlComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDragMovementControlComponent.h"

@interface OGDragMovementControlComponent ()

@property (nonatomic, assign) BOOL isMooving;

@end

@implementation OGDragMovementControlComponent

- (void)touchMovedToPoint:(CGPoint)point
{
    if (self.isMooving && self.node)
    {
        self.node.position = point;
    }
}

- (void)touchBeganAtPoint:(CGPoint)point
{
    if (CGRectContainsPoint(self.node.frame, point))
    {
        self.isMooving = YES;
        self.node.position = point;
    }
}

- (void)touchEndedAtPoint:(CGPoint)point
{
    self.isMooving = NO;
}

@end
