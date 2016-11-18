//
//  OGDoorEntityOpenedState.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDoorEntityClosedState.h"
#import "OGDoorEntityOpenedState.h"
#import "OGDoorEntityLockedState.h"
#import "OGDoorEntityUnlockedState.h"
#import "OGCollisionBitMask.h"

#import "OGLockComponent.h"
#import "OGRenderComponent.h"

@implementation OGDoorEntityOpenedState

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    self.lockComponent.closed = NO;
    ((SKSpriteNode *) self.renderComponent.node).color = [SKColor clearColor];
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == OGDoorEntityClosedState.self
    || stateClass == OGDoorEntityLockedState.self
    || stateClass == OGDoorEntityLockedState.self;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    if (!self.lockComponent.isLocked)
    {        
        if (!self.lockComponent.isClosed && ![self isTargetNearDoor])
        {
            if ([self.stateMachine canEnterState:OGDoorEntityClosedState.self])
            {
                [self.stateMachine enterState:OGDoorEntityClosedState.self];
            }
        }
    }
    else
    {
        if ([self.stateMachine canEnterState:OGDoorEntityLockedState.self])
        {
            [self.stateMachine enterState:OGDoorEntityLockedState.self];
        }
    }
}

@end
