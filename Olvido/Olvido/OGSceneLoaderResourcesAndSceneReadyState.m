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
    return stateClass == [OGSceneLoaderResourcesReadyState class];
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    [self.sceneLoader.delegate sceneLoaderDidComplete:self.sceneLoader];
}

@end
