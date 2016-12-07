//
//  OGSceneLoaderResourcesReadyWithoutScene.m
//  Olvido
//
//  Created by Алексей Подолян on 11/29/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneLoaderInitialState.h"
#import "OGSceneLoaderPrepearingSceneState.h"
#import "OGSceneLoaderResourcesReadyState.h"

@implementation OGSceneLoaderResourcesReadyState

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;
    
    result = (stateClass == [OGSceneLoaderPrepearingSceneState class])
          || (stateClass == [OGSceneLoaderInitialState class]);
    
    return result;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    self.sceneLoader.scene = nil;
}

@end
