//
//  OGSceneLoaderResourcesReadyState.m
//  Olvido
//
//  Created by Алексей Подолян on 11/9/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneLoaderResourcesReadyState.h"
#import "OGSceneLoaderInitialState.h"

@implementation OGSceneLoaderResourcesReadyState

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [OGSceneLoaderInitialState class];
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    self.sceneLoader.progress = nil;
    
    [self.sceneLoader.delegate sceneLoaderDidComplete:self.sceneLoader];
}

- (void)willExitWithNextState:(GKState *)nextState
{
    [super willExitWithNextState:nextState];
    
    self.sceneLoader.scene = nil;
}

@end
