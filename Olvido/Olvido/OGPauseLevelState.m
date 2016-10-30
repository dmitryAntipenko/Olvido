//
//  OGPauseLevelState.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPauseLevelState.h"
#import "OGGameLevelState.h"
#import "OGBeforeStartLevelState.h"
#import "OGGameScene.h"

@implementation OGPauseLevelState

+ (instancetype)stateWithLevelScene:(OGGameScene *)scene
{
    OGPauseLevelState *state = nil;
    
    if (scene)
    {
        state = [[[OGPauseLevelState alloc] initWithLevelScene:scene] autorelease];
    }
    
    return state;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [self.scene pause];
}

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;
    
    result = (result || stateClass == [OGGameLevelState class]);
    result = (result || stateClass == [OGBeforeStartLevelState class]);
    
    return result;
}

@end
