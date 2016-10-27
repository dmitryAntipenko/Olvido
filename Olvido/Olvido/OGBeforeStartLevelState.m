//
//  OGInitLevelState.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGBeforeStartLevelState.h"
#import "OGGameLevelState.h"
#import "OGGameScene.h"

@implementation OGBeforeStartLevelState

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [self.scene restart];
}

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;
    
    result = (result || stateClass == [OGGameLevelState class]);
    
    return result;
}

@end
