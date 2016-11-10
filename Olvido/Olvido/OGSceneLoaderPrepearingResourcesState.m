//
//  OGSceneLoaderPrepearingResourcesState.m
//  Olvido
//
//  Created by Алексей Подолян on 11/9/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneLoaderPrepearingResourcesState.h"
#import "OGSceneLoaderResourcesReadyState.h"
#import "OGSceneLoader.h"
#import "OGSceneMetadata.h"
#import "OGLoadSceneOperation.h"

NSUInteger const kOGSceneLoaderPrepearingResourcesStateSceneFileUnitCount = 1;
NSUInteger const kOGSceneLoaderPrepearingResourcesStatePendingUnitCount = 1;

@interface OGSceneLoaderPrepearingResourcesState ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSProgress *progress;

@end

@implementation OGSceneLoaderPrepearingResourcesState

- (void)didEnterWithPreviousState:(GKState *)state
{
    //    [self load]
}

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;
    
    result = (stateClass == [OGSceneLoaderResourcesReadyState class]);
    result = result || (stateClass == [OGSceneLoaderResourcesReadyState class]);
    
    return result;
}

- (void)loadResourcesAsunchronously
{
    OGSceneMetadata *sceneMetadata = self.sceneLoader.metadata;
    
    self.progress = [NSProgress progressWithTotalUnitCount:sceneMetadata.loadableClasses.count
                     + kOGSceneLoaderPrepearingResourcesStateSceneFileUnitCount];
    
    if (self.sceneLoader.progress)
    {
        [self.sceneLoader.progress addChild:self.progress
                       withPendingUnitCount: kOGSceneLoaderPrepearingResourcesStatePendingUnitCount];
    }
    
    
}

- (void)cancel
{
    
}

@end
