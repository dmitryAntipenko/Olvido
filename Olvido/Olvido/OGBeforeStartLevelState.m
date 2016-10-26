//
//  OGBeforeStartLevelState.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGBeforeStartLevelState.h"
#import "OGInitLevelState.h"
#import "OGGameScene.h"

@implementation OGBeforeStartLevelState

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [self.scene pause];
}

- (void)willExitWithNextState:(GKState *)nextState
{
    
}

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;

    result = (result || stateClass == [OGInitLevelState class]);
    
    return result;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    
}

@end
