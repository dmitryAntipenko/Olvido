//
//  OGSceneLoaderPrepearingResourcesState.m
//  Olvido
//
//  Created by Алексей Подолян on 11/9/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTextureAtlasesManager.h"
#import "OGSceneLoaderPrepearingResourcesState.h"
#import "OGSceneLoaderPrepearingSceneState.h"
#import "OGSceneLoader.h"
#import "OGSceneMetadata.h"
#import "OGLoadSceneOperation.h"
#import "OGLoadLoadableClassOperation.h"
#import "OGLoadTexturesOperation.h"

@interface OGSceneLoaderPrepearingResourcesState ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;

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
    BOOL result = NO;
    
    result = (stateClass == [OGSceneLoaderPrepearingSceneState class]);
    
    return result ;
}

- (void)loadResourcesAsynchronously
{   
    OGSceneMetadata *sceneMetadata = self.sceneLoader.metadata;
    
    OGLoadSceneOperation *loadSceneOperation = [OGLoadSceneOperation loadSceneOperationWithSceneMetadata:sceneMetadata];
    
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
//                       [strongSelf.stateMachine enterState:[OGSceneLoaderResourcesAndSceneReadyState class]];
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
            
            [loadSceneOperation addDependency:loadTexturesOperation];
            
            [self.operationQueue addOperation:loadTexturesOperation];
        }
    }
    
    for (Class<OGResourceLoadable> loadableClass in sceneMetadata.loadableClasses)
    {
        OGLoadLoadableClassOperation *loadLoadableClassOperation = [OGLoadLoadableClassOperation loadResourcesOperationWithLoadableClass:loadableClass];
        
        [loadSceneOperation addDependency:loadLoadableClassOperation];
        
        [self.operationQueue addOperation:loadLoadableClassOperation];
    }
    
    [self.operationQueue addOperation:loadSceneOperation];
}

@end
