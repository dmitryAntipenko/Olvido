//
//  OGDoorEntityUnlockedState.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDoorEntityUnlockedState.h"
#import "OGDoorEntityOpenedState.h"

#import "OGColliderType.h"

#import "OGLockComponent.h"
#import "OGRenderComponent.h"

@implementation OGDoorEntityUnlockedState

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];    
    
    if ([self.stateMachine canEnterState:[OGDoorEntityOpenedState class]])
    {
        [self.stateMachine enterState:[OGDoorEntityOpenedState class]];
    }
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [OGDoorEntityOpenedState class];
}

@end
