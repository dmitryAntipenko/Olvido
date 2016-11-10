//
//  OGSceneLoaderPrepearingResourcesState.m
//  Olvido
//
//  Created by Алексей Подолян on 11/9/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneLoaderPrepearingResourcesState.h"
#import "OGSceneLoaderResourcesReadyState.h"
#import "OGSceneLoaderInitialState.h"
#import "OGSceneLoader.h"
#import "OGSceneMetadata.h"
#import "OGLoadSceneOperation.h"
#import "OGLoadResourcesOPeration.h"

NSUInteger const kOGSceneLoaderPrepearingResourcesStateSceneFileUnitCount = 1;
NSUInteger const kOGSceneLoaderPrepearingResourcesStatePendingUnitCount = 1;

@interface OGSceneLoaderPrepearingResourcesState ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSProgress *progress;

@end

@implementation OGSceneLoaderPrepearingResourcesState

- (void)didEnterWithPreviousState:(GKState *)state
{
    [self loadResourcesAsunchronously];
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _operationQueue = [NSOperationQueue currentQueue];
    }
    
    return self;
}

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;
    
    result = (stateClass == [OGSceneLoaderResourcesReadyState class]);
    
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
    
    OGLoadSceneOperation *loadSceneOperation = [OGLoadSceneOperation loadSceneOperationWithSceneMetadata:sceneMetadata];
    
    [self.progress addChild:loadSceneOperation.progress withPendingUnitCount:kOGSceneLoaderPrepearingResourcesStatePendingUnitCount];
    
    __block OGLoadSceneOperation *weakLoadSceneOperation = loadSceneOperation;
    
    loadSceneOperation.completionBlock = ^
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           self.sceneLoader.scene = weakLoadSceneOperation.scene;
                           
                           [self.stateMachine enterState:[OGSceneLoaderResourcesReadyState class]];
                       });
    };
    
    for (Class<OGResourceLoadable> loadableClass in sceneMetadata.loadableClasses)
    {
        OGLoadResourcesOperation *loadResourceOperation = [OGLoadResourcesOperation loadResourcesOperationWithLoadableClass:loadableClass];
        
        [self.progress addChild:loadResourceOperation.progress withPendingUnitCount:kOGSceneLoaderPrepearingResourcesStatePendingUnitCount];
        
        [loadSceneOperation addDependency:loadResourceOperation];
        
        [self.operationQueue addOperation:loadResourceOperation];
    }
    
    [self.operationQueue addOperation:loadSceneOperation];
}

- (void)cancel
{
    [self.operationQueue cancelAllOperations];
    self.sceneLoader.scene = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [self.stateMachine enterState:OGSceneLoaderInitialState.self];
                   });
}

@end
