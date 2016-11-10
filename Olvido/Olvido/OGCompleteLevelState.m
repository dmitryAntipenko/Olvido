//
//  OGCompleteLevelState.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGCompleteLevelState.h"
#import "OGBeforeStartLevelState.h"

@implementation OGCompleteLevelState

+ (instancetype)stateWithLevelScene:(OGGameScene *)scene
{
    OGCompleteLevelState *state = nil;
    
    if (scene)
    {
        state = [[OGCompleteLevelState alloc] initWithLevelScene:scene];
    }
    
    return state;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    
}

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;
    
    result = (result || stateClass == OGBeforeStartLevelState.self);
    
    return result;
}

@end
