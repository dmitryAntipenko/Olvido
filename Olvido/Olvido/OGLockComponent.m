//
//  OGLockComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLockComponent.h"
#import "OGRenderComponent.h"

@implementation OGLockComponent

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    if (!self.isLocked)
    {
        SKNode *doorNode = ((OGRenderComponent *) [self.entity componentForClass:OGRenderComponent.self]).node;
        CGFloat distance = hypot(doorNode.position.x - self.target.position.x,
                                 doorNode.position.y - self.target.position.y);
        
        if (distance < self.openDistance)
        {
            [self.delegate shouldOpen];
        }
        else
        {
            [self.delegate shouldClose];
        }
    }
}

@end
