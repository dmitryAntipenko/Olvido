//
//  OGDoorEntityLockedState.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDoorEntityLockedState.h"
#import "OGDoorEntityUnlockedState.h"

#import "OGColliderType.h"

#import "OGLockComponent.h"
#import "OGRenderComponent.h"
#import "OGPhysicsComponent.h"

@implementation OGDoorEntityLockedState

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    self.lockComponent.closed = YES;
    
    SKNode *doorNode = self.renderComponent.node;
    self.physicsComponent = [[OGPhysicsComponent alloc] initWithPhysicsBody:doorNode.physicsBody colliderType:[OGColliderType lockedDoor]];
    
    doorNode.physicsBody.dynamic = NO;
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [OGDoorEntityUnlockedState class];
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    if (!self.lockComponent.isLocked)
    {
        if ([self.stateMachine canEnterState:[OGDoorEntityUnlockedState class]])
        {
            [self.stateMachine enterState:[OGDoorEntityUnlockedState class]];
        }
    }
}

@end
