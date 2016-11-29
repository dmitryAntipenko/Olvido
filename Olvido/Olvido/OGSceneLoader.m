//
//  OGSceneLoader.m
//  Olvido
//
//  Created by Алексей Подолян on 11/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneLoader.h"
#import "OGSceneMetadata.h"
#import "OGConstants.h"
#import "OGBaseScene.h"
#import "OGSceneLoaderInitialState.h"
#import "OGSceneLoaderPrepearingResourcesState.h"
#import "OGSceneLoaderResourcesAndSceneReadyState.h"
#import "OGSceneLoaderResourcesReadyState.h"
#import "OGSceneLoaderPrepearingSceneState.h"

@implementation OGSceneLoader

- (instancetype)initWithMetadata:(OGSceneMetadata *)metadata
{
    if (metadata)
    {
        self = [self init];
        
        if (self)
        {
            _metadata = metadata;
            _stateMachine = [GKStateMachine stateMachineWithStates:@[
                                                                     [OGSceneLoaderInitialState stateWithSceneLoader:self],
                                                                     [OGSceneLoaderPrepearingResourcesState stateWithSceneLoader:self],
                                                                     [OGSceneLoaderResourcesAndSceneReadyState stateWithSceneLoader:self],
                                                                     [OGSceneLoaderResourcesReadyState stateWithSceneLoader:self],
                                                                     [OGSceneLoaderPrepearingSceneState stateWithSceneLoader:self]
                                                                     ]];
            
            [_stateMachine enterState:[OGSceneLoaderInitialState class]];
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

+ (instancetype)sceneLoaderWithMetadata:(OGSceneMetadata *)metadata
{
    return [[self alloc] initWithMetadata:metadata];
}

- (void)asynchronouslyLoadSceneForPresentation;
{
    if (self.stateMachine.currentState.class == [OGSceneLoaderInitialState class])
    {
        [self.stateMachine enterState:[OGSceneLoaderPrepearingResourcesState class]];
    }
    else if (self.stateMachine.currentState.class == [OGSceneLoaderResourcesReadyState class])
    {
        [self.stateMachine enterState:[OGSceneLoaderPrepearingSceneState class]];
    }
}

- (void)purgeResources
{
    [self.stateMachine enterState:[OGSceneLoaderInitialState class]];
}

- (void)purgeScene
{
    [self.stateMachine enterState:[OGSceneLoaderResourcesReadyState class]];
}

@end
