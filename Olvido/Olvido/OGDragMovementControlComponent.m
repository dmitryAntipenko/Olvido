//
//  OGTrackControlComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDragMovementControlComponent.h"
#import "OGVisualComponent.h"
#import "OGSpriteNode.h"

@interface OGDragMovementControlComponent ()

@property (nonatomic, assign) BOOL isMooving;

@end

@implementation OGDragMovementControlComponent

- (void)touchMovedToPoint:(CGPoint)point
{
    if (self.isMooving && self.visualComponent)
    {
        self.visualComponent.spriteNode.position = point;
    }
}

- (void)touchBeganAtPoint:(CGPoint)point
{
    if (CGRectContainsPoint(self.visualComponent.spriteNode.frame, point))
    {
        self.isMooving = YES;
        self.visualComponent.spriteNode.position = point;
    }
}

- (void)touchEndedAtPoint:(CGPoint)point
{
    self.isMooving = NO;
}

@end
