//
//  OGScreenNode.m
//  Olvido
//
//  Created by Алексей Подолян on 12/11/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGScreenNode.h"

@interface OGScreenNode ()

@property (nonatomic, assign) BOOL scaled;

@end

@implementation OGScreenNode

- (void)addToNode:(SKNode *)node
{
    if (node)
    {
        if (!self.scaled)
        {
            [self updateScaleWithParentNode:node];
            self.scaled = YES;
        }
        
        [node addChild:self];
    }
}

- (void)updateScaleWithParentNode:(SKNode *)parent
{
    if (parent)
    {
        CGSize parentFrameSize = [parent calculateAccumulatedFrame].size;
        CGSize selfSize = [self calculateAccumulatedFrame].size;
        
        if (selfSize.width != parentFrameSize.width)
        {
            self.xScale = parentFrameSize.width / selfSize.width;
            self.yScale = self.xScale;
        }
    }
}

@end
