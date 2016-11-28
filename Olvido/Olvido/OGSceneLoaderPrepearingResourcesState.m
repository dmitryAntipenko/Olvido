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
#import "OGLoadLoadableClassOperation.h"
#import "OGLoadTexturesOperation.h"

NSUInteger const OGSceneLoaderPrepearingResourcesStateSceneFileUnitCount = 1;
NSUInteger const OGSceneLoaderPrepearingResourcesStatePendingUnitCount = 1;

@interface OGSceneLoaderPrepearingResourcesState ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSProgress *progress;

@end

@implementation OGSceneLoaderPrepearingResourcesState

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _operationQueue = [NSOperationQueue currentQueue];
    }
    
    return self;
}

- (void)didEnterWithPreviousState:(GKState *)state
{
    [super didEnterWithPreviousState:state];
    
    [self loadResourcesAsynchronously];
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [OGSceneLoaderResourcesReadyState class];
}

- (void)loadResourcesAsynchronously
{
    OGSceneMetadata *sceneMetadata = self.sceneLoader.metadata;
    
    self.progress = [NSProgress progressWithTotalUnitCount:sceneMetadata.loadableClasses.count
                     + OGSceneLoaderPrepearingResourcesStateSceneFileUnitCount];
    
    if (self.sceneLoader.progress)
    {
        [self.sceneLoader.progress addChild:self.progress
                       withPendingUnitCount: OGSceneLoaderPrepearingResourcesStatePendingUnitCount];
    }
    
    OGLoadSceneOperation *loadSceneOperation = [OGLoadSceneOperation loadSceneOperationWithSceneMetadata:sceneMetadata];
    
    [self.progress addChild:loadSceneOperation.progress withPendingUnitCount:OGSceneLoaderPrepearingResourcesStatePendingUnitCount];
    
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
                       [strongSelf.stateMachine enterState:[OGSceneLoaderResourcesReadyState class]];
                   }
               });
        }
    };
    
    for (NSString *unitName in sceneMetadata.textureAtlases)
    {
        NSDictionary<NSString *, NSString *> *unitAtlases = [sceneMetadata.textureAtlases objectForKey:unitName];
        
        for (NSString *atlasKey in unitAtlases)
        {
            OGLoadTexturesOperation *loadTexturesOperation = [OGLoadTexturesOperation loadTexturesOperationWithUnitName:unitName
                                                                                                               atlasKey:atlasKey
                                                                                                              atlasName:unitAtlases[atlasKey]];
            
            [self.progress addChild:loadTexturesOperation.progress withPendingUnitCount:OGSceneLoaderPrepearingResourcesStatePendingUnitCount];
            
            [loadSceneOperation addDependency:loadTexturesOperation];
            
            [self.operationQueue addOperation:loadTexturesOperation];
        }
    }
    
    for (Class<OGResourceLoadable> loadableClass in sceneMetadata.loadableClasses)
    {
        OGLoadLoadableClassOperation *loadLoadableClassOperation = [OGLoadLoadableClassOperation loadResourcesOperationWithLoadableClass:loadableClass];
        
        [self.progress addChild:loadLoadableClassOperation.progress withPendingUnitCount:OGSceneLoaderPrepearingResourcesStatePendingUnitCount];
        
        [loadSceneOperation addDependency:loadLoadableClassOperation];
        
        [self.operationQueue addOperation:loadLoadableClassOperation];
    }
    
    [self.operationQueue addOperation:loadSceneOperation];
}

- (void)cancel
{
    [self.operationQueue cancelAllOperations];
    self.sceneLoader.scene = nil;
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^
       {
           if (weakSelf)
           {
               typeof(weakSelf) strongSelf = weakSelf;
               
               [strongSelf.stateMachine enterState:[OGSceneLoaderInitialState class]];
           }
       });
}

@end
