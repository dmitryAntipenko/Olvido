//
//  OGSceneLoaderResourcesReadyWithoutScene.m
//  Olvido
//
//  Created by Алексей Подолян on 11/29/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneLoaderInitialState.h"
#import "OGSceneLoaderPrepearingResourcesState.h"
#import "OGSceneLoaderResourcesReadyState.h"
#import "OGSceneMetadata.h"
#import "OGSceneLoaderResourcesReadyWithoutScene.h"

@implementation OGSceneLoaderResourcesReadyWithoutScene

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;
    
    result = (stateClass == [OGSceneLoaderPrepearingResourcesState class]);
    result = result || (stateClass == [OGSceneLoaderResourcesReadyState class]);
    result = result || (stateClass == [OGSceneLoaderInitialState class]);
    
    return result;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    self.sceneLoader.scene = nil;
}

@end
