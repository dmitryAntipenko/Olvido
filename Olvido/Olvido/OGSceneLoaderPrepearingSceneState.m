//
//  OGSceneLoaderPrepearingSceneState.m
//  Olvido
//
//  Created by Алексей Подолян on 11/29/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneLoaderResourcesAndSceneReadyState.h"
#import "OGSceneLoaderPrepearingSceneState.h"

@implementation OGSceneLoaderPrepearingSceneState

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;
    
    result = (stateClass == [OGSceneLoaderResourcesAndSceneReadyState class]);
    
    return result;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    self.sceneLoader.scene = nil;
}

@end
