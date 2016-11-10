//
//  OGDoorEntityClosedState.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDoorEntityClosedState.h"
#import "OGDoorEntityOpenedState.h"

#import "OGLockComponent.h"
#import "OGRenderComponent.h"

@implementation OGDoorEntityClosedState

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    self.lockComponent.closed = YES;
    ((SKSpriteNode *) self.renderComponent.node).color = [SKColor blueColor];
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == OGDoorEntityOpenedState.self;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    if (!self.lockComponent.isLocked)
    {
        SKNode *target = self.lockComponent.target;
        SKNode *doorNode = self.renderComponent.node;
        
        CGFloat distance = hypot(doorNode.position.x - target.position.x,
                                 doorNode.position.y - target.position.y);
        
        if (self.lockComponent.isClosed && distance < self.lockComponent.openDistance)
        {
            if ([self.stateMachine canEnterState:OGDoorEntityOpenedState.self])
            {
                [self.stateMachine enterState:OGDoorEntityOpenedState.self];
            }
        }
    }
}

@end
