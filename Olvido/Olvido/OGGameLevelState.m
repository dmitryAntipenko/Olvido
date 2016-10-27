//
//  OGGameLevelState.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameLevelState.h"
#import "OGPauseLevelState.h"
#import "OGCompleteLevelState.h"
#import "OGDeathLevelState.h"
#import "OGGameScene.h"

@implementation OGGameLevelState

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [self.scene resume];
}

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;
    
    result = (result || stateClass == [OGPauseLevelState class]);
    result = (result || stateClass == [OGCompleteLevelState class]);
    result = (result || stateClass == [OGDeathLevelState class]);
    
    return result;
}

@end
