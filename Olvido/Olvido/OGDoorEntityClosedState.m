//
//  OGDoorEntityClosedState.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDoorEntityClosedState.h"
#import "OGDoorEntityOpenedState.h"
#import "OGDoorEntityLockedState.h"
#import "OGDoorEntityUnlockedState.h"

#import "OGDoorEntity.h"
#import "OGLockComponent.h"
#import "OGRenderComponent.h"
#import "OGPhysicsComponent.h"

@implementation OGDoorEntityClosedState

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    self.lockComponent.closed = YES;
    ((SKSpriteNode *) self.renderComponent.node).color = [SKColor blueColor];
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == OGDoorEntityOpenedState.self
    || stateClass == OGDoorEntityLockedState.self
    || stateClass == OGDoorEntityLockedState.self;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    if (!self.lockComponent.isLocked)
    {        
        if (self.lockComponent.isClosed && [self isTargetNearDoor])
        {
            if ([self.stateMachine canEnterState:OGDoorEntityOpenedState.self])
            {
                [self.stateMachine enterState:OGDoorEntityOpenedState.self];
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
