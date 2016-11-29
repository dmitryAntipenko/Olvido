//
//  OGSceneLoaderResourcesReadyState.m
//  Olvido
//
//  Created by Алексей Подолян on 11/9/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneLoaderResourcesAndSceneReadyState.h"
#import "OGSceneLoaderResourcesReadyState.h"
#import "OGSceneLoaderInitialState.h"

@implementation OGSceneLoaderResourcesAndSceneReadyState

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;
    
    result = (stateClass == [OGSceneLoaderInitialState class]);
    result = result || (stateClass == [OGSceneLoaderResourcesReadyState class]);
    
    return result;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    [self.sceneLoader.delegate sceneLoaderDidComplete:self.sceneLoader];
}

@end
