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
#import "OGSceneLoaderResourcesReadyState.h"

NSUInteger const kOGSceneLoaderProgressTotalCountWhenResourcesReady = 0;
NSUInteger const kOGSceneLoaderProgressTotalCountWhenResourcesAvailable = 1;

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
                [OGSceneLoaderResourcesReadyState stateWithSceneLoader:self]
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

- (NSProgress *)asynchronouslyLoadSceneForPresentation;
{
    if (self.stateMachine.currentState.class == [OGSceneLoaderResourcesReadyState class])
    {
        self.progress = [NSProgress progressWithTotalUnitCount:kOGSceneLoaderProgressTotalCountWhenResourcesReady];
    }
    else if (self.stateMachine.currentState.class == [OGSceneLoaderInitialState class])
    {
        self.progress = [NSProgress progressWithTotalUnitCount:kOGSceneLoaderProgressTotalCountWhenResourcesAvailable];
        [self.stateMachine enterState:[OGSceneLoaderPrepearingResourcesState class]];
    }
    
    return self.progress;
}

- (void)purgeResources
{
    [self.progress cancel];
    
    [self.stateMachine enterState:[OGSceneLoaderInitialState class]];
}

@end
