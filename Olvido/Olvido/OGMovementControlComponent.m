//
//  OGMovementControlComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMovementControlComponent.h"

@implementation OGMovementControlComponent

- (instancetype)initWithNode:(SKNode *)node
{
    self = [super init];
    
    if (self)
    {
        _node = [node retain];
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

- (void)stop
{
    
}

- (void)dealloc
{
    [_node release];
    
    [super dealloc];
}

@end
