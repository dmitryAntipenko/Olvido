//
//  OGSceneManager.m
//  Olvido
//
//  Created by Алексей Подолян on 11/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneManager.h"
#import "OGBaseScene.h"
#import "OGSceneLoader.h"
#import "OGConstants.h"
#import "OGSceneMetadata.h"
#import "OGSceneLoaderInitialState.h"
#import "OGSceneLoaderPrepearingResourcesState.h"
#import "OGSceneLoaderResourcesReadyState.h"
#import "OGLoadingScene.h"
#import "OGSceneLoaderDelegate.h"

NSString *const OGSceneManagerLoadingSceneFileName = @"OGLoadingScene";
NSString *const OGSceneManagerScenesConfigurationFileName = @"ScenesConfiguration";
CGFloat const OGSceneManagerTransitionTimeInterval = 0.6;
NSUInteger const OGSceneManagerInitialSceneIdentifier = 0;

@interface OGSceneManager () <OGSceneLoaderDelegate>

@property (nonatomic, strong) OGSceneLoader *nextSceneLoader;
@property (nonatomic, strong) NSMutableArray<OGSceneLoader *> *sceneLoaders;
@property (nonatomic, strong) OGLoadingScene *loadingScene;
@property (nonatomic, strong) OGSceneLoader *currentSceneLoader;
@property (nonatomic, strong) void (^transitionCompletion)(OGBaseScene *scene);

@end

@implementation OGSceneManager

- (instancetype)initWithView:(SKView *)view
{
    self = [self init];
    
    if (self)
    {
        NSString *pathForScenesConfiguration = [[NSBundle mainBundle] pathForResource:OGSceneManagerScenesConfigurationFileName
                                                                               ofType:OGPropertyFileExtension];
        
        if (pathForScenesConfiguration)
        {
            NSArray *configuration = [NSArray arrayWithContentsOfFile:pathForScenesConfiguration];
            
            __block NSMutableArray *mutableSceneLoaders = [NSMutableArray array];
            
            [configuration enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop)
             {
                 OGSceneMetadata *sceneMetadata = [OGSceneMetadata sceneMetaDataWithSceneConfiguration:obj
                                                                                            identifier:idx];
                 OGSceneLoader *sceneLoader = [OGSceneLoader sceneLoaderWithMetadata:sceneMetadata];
                 sceneLoader.delegate = self;
                 [mutableSceneLoaders addObject:sceneLoader];
             }];
            
            _sceneLoaders = [mutableSceneLoaders copy];
            _view = view;
            
            _transitionCompletion = nil;
        }
        else
        {
            self = nil;
        }
    }
    
    return self;
}

+ (instancetype)sceneManagerWithView:(SKView *)view
{
    return [[OGSceneManager alloc] initWithView:view];
}

- (void)prepareSceneWithIdentifier:(NSUInteger)sceneIdentifier
{
    OGSceneLoader *sceneLoader = [self sceneLoaderForIdentifier:sceneIdentifier];
    
    if (sceneLoader.stateMachine.currentState.class == [OGSceneLoaderInitialState class])
    {
        [sceneLoader asynchronouslyLoadSceneForPresentation];
    }
}

- (void)transitionToSceneWithIdentifier:(NSUInteger)sceneIdentifier completionHandler:(void (^)(OGBaseScene *scene))completion;
{
    self.transitionCompletion = completion;
    
    OGSceneLoader *sceneLoader = [self sceneLoaderForIdentifier:sceneIdentifier];
    
    if (sceneLoader.stateMachine.currentState.class == [OGSceneLoaderResourcesReadyState class])
    {
        [self presentSceneWithSceneLoader:sceneLoader];
    }
    else
    {
        [sceneLoader asynchronouslyLoadSceneForPresentation];
        sceneLoader.requestedForPresentation = YES;
        
        [self presentLoadingSceneWithSceneLoader:sceneLoader];
    }
}

- (OGSceneLoader *)sceneLoaderForIdentifier:(NSUInteger)identifier
{
    OGSceneLoader *result = nil;
    
    for (OGSceneLoader *sceneLoader in self.sceneLoaders)
    {
        if (sceneLoader.metadata.identifier == identifier)
        {
            result = sceneLoader;
        }
    }
    
    return result;
}

- (void)presentLoadingSceneWithSceneLoader:(OGSceneLoader *)sceneLoader
{
    if (!self.loadingScene)
    {
        self.loadingScene = [OGLoadingScene loadingSceneWithSceneLoader:sceneLoader];
        self.loadingScene.sceneManager = self;
        
        SKTransition *transition = [SKTransition fadeWithDuration:OGSceneManagerTransitionTimeInterval];
        
        [self.view presentScene:self.loadingScene transition:transition];
    }
}

- (void)sceneLoaderDidComplete:(OGSceneLoader *)sceneLoader
{
    
    if (sceneLoader.requestedForPresentation)
    {
        [self presentSceneWithSceneLoader:sceneLoader];
        self.loadingScene = nil;
        
        sceneLoader.requestedForPresentation = NO;
    }
}

- (void)presentSceneWithSceneLoader:(OGSceneLoader *)sceneLoader
{
    [self.currentSceneLoader purgeResources];
    
    if (self.transitionCompletion)
    {
        self.transitionCompletion(sceneLoader.scene);
        self.transitionCompletion = nil;
    }
    
    SKTransition *transition = [SKTransition fadeWithDuration:OGSceneManagerTransitionTimeInterval];
    [self.view presentScene:sceneLoader.scene transition:transition];
    
    self.currentSceneLoader = sceneLoader;
}

- (void)transitionToInitialSceneWithCompletionHandler:(void (^)(OGBaseScene *scene))completion;
{
    [self transitionToSceneWithIdentifier:OGSceneManagerInitialSceneIdentifier completionHandler:completion];
}

@end
