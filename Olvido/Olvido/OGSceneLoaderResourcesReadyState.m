//
//  OGSceneLoaderResourcesReadyState.m
//  Olvido
//
//  Created by Алексей Подолян on 11/9/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneLoaderResourcesReadyState.h"
#import "OGSceneLoaderInitialState.h"

NSString *const kOGSceneLoaderDidCompleteNotification = @"sceneLoaderDidCompleteNotification";

@implementation OGSceneLoaderResourcesReadyState

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;
    
    result = (stateClass == OGSceneLoaderInitialState.self);
    
    return result;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    self.sceneLoader.progress = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kOGSceneLoaderDidCompleteNotification object:self.sceneLoader];
}

@end
