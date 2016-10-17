//
//  OGTrackControlComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTrackMovementControlComponent.h"

@implementation OGTrackMovementControlComponent

- (void)touchMovedToPoint:(CGPoint)point
{
    if (self.node)
    {
        self.node.position = point;
    }
}

@end
