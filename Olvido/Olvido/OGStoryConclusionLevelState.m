//
//  OGBeforeStartLevelState.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGStoryConclusionLevelState.h"
#import "OGBeforeStartLevelState.h"
#import "OGGameScene.h"

@implementation OGStoryConclusionLevelState

+ (instancetype)stateWithLevelScene:(OGGameScene *)scene
{
    OGStoryConclusionLevelState *state = nil;
    
    if (scene)
    {
        state = [[OGStoryConclusionLevelState alloc] initWithLevelScene:scene];
    }
    
    return state;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [self.scene pauseWithPauseScreen];
}

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;

    result = (result || stateClass == [OGBeforeStartLevelState class]);
    
    return result;
}

@end
