//
//  OGDeathLevelState.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDeathLevelState.h"
#import "OGBeforeStartLevelState.h"
#import "OGGameScene.h"

@implementation OGDeathLevelState

+ (instancetype)stateWithLevelScene:(OGGameScene *)scene
{
    OGDeathLevelState *state = nil;
    
    if (scene)
    {
        state = [[OGDeathLevelState alloc] initWithLevelScene:scene];
    }
    
    return state;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [self.scene gameOver];
}

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;
    
    result = (result || stateClass == [OGBeforeStartLevelState class]);
    
    return result;
}

@end
