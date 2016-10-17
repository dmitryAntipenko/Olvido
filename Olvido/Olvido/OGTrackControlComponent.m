//
//  OGTrackControlComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTrackControlComponent.h"

@interface OGTrackControlComponent ()

@property (nonatomic, retain) SKNode *node;

@end

@implementation OGTrackControlComponent

- (instancetype)initWithNode:(SKNode *)node
{
    self = [self init];
    
    if (self)
    {
        _node = [node retain];
    }
    
    return self;
}

- (void)moveToPoint:(CGPoint)point
{
    if (self.node)
    {
        self.node.position = point;
    }
}

- (void)moveOnVector:(CGVector)vector
{
    if (self.node)
    {
        self.node.position = CGPointMake(self.node.position.x + vector.dx,
                                         self.node.position.y + vector.dy);
    }
}

@end
