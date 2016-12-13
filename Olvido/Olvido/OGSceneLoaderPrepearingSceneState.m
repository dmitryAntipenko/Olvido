//
//  OGSceneLoaderPrepearingSceneState.m
//  Olvido
//
//  Created by Алексей Подолян on 11/29/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneLoaderResourcesAndSceneReadyState.h"
#import "OGSceneLoaderPrepearingSceneState.h"
#import "OGLoadSceneOperation.h"

@implementation OGSceneLoaderPrepearingSceneState

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [OGSceneLoaderResourcesAndSceneReadyState class];
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    OGLoadSceneOperation *loadSceneOperation = [OGLoadSceneOperation loadSceneOperationWithSceneMetadata:self.sceneLoader.metadata];
    
    __weak typeof(self) weakSelf = self;
    __weak OGLoadSceneOperation *weakLoadSceneOperation = loadSceneOperation;
    
    
    loadSceneOperation.completionBlock = ^
    {
        if (weakLoadSceneOperation)
        {
            OGLoadSceneOperation *strongLoadSceneOperation = weakLoadSceneOperation;
            
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               if (weakSelf)
                               {
                                   typeof(weakSelf) strongSelf = weakSelf;
                                   
                                   strongSelf.sceneLoader.scene = strongLoadSceneOperation.scene;
                                   [strongSelf.stateMachine enterState:[OGSceneLoaderResourcesAndSceneReadyState class]];
                               }
                           });
        }
    };
    
    [loadSceneOperation start];
}

@end
