//
//  OGSceneLoaderResourcesReadyState.m
//  Olvido
//
//  Created by Алексей Подолян on 11/9/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneLoaderResourcesReadyState.h"
#import "OGSceneLoaderResourcesReadyWithoutScene.h"
#import "OGSceneLoaderInitialState.h"

@implementation OGSceneLoaderResourcesReadyState

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;
    
    result = (stateClass == [OGSceneLoaderInitialState class]);
    result = result || (stateClass == [OGSceneLoaderResourcesReadyWithoutScene class]);
    
    return result;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    [self.sceneLoader.delegate sceneLoaderDidComplete:self.sceneLoader];
}

- (void)willExitWithNextState:(GKState *)nextState
{
    [super willExitWithNextState:nextState];
}

@end
