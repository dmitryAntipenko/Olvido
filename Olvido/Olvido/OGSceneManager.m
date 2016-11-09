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

NSString *const kOGSceneManagerScenesConfigurationFileName = @"ScenesConfiguration";
CGFloat const kOGSceneManagerTransitionTimeInterval = 0.6;
NSUInteger const kOGSceneManagerInitialSceneIdentifier = 0;

@interface OGSceneManager ()

@property (nonatomic, strong) OGBaseScene *currentScene;
@property (nonatomic, strong) OGSceneLoader *nextSceneLoader;
@property (nonatomic, strong) NSMutableArray<OGSceneLoader *> *sceneLoaders;

@end

@implementation OGSceneManager

- (instancetype)initWithView:(SKView *)view
{
    self = [self init];
    
    if (self)
    {
        NSString *pathForScenesConfiguration = [[NSBundle mainBundle] pathForResource:kOGSceneManagerScenesConfigurationFileName
                                                                               ofType:kOGPropertyFileExtension];
        
        if (pathForScenesConfiguration)
        {
            NSArray *configuration = [NSArray arrayWithContentsOfFile:pathForScenesConfiguration];
            
            __block NSMutableArray *mutableSceneLoaders = [NSMutableArray array];
            
            [configuration enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop)
            {
                OGSceneMetadata *sceneMetadata = [OGSceneMetadata sceneMetaDataWithSceneConfiguration:obj
                                                                                           identifier:idx];
                OGSceneLoader *sceneLoader = [OGSceneLoader sceneLoaderWithMetadata:sceneMetadata];
                [mutableSceneLoaders addObject:sceneLoader];
            }];
            
            _sceneLoaders = [mutableSceneLoaders copy];
        }
        
        _view = view;
    }
    
    return self;
}

+ (instancetype)sceneManagerWithView:(SKView *)view
{
    return [[OGSceneManager alloc] initWithView:view];
}

- (void)prepareSceneWithIdentifier:(NSUInteger)sceneIdentifier
{
//    OGSceneLoader *sceneLoader = [self sceneLoaderForIdentifier:sceneIdentifier];
//    
//    if (sceneLoader.stateMachine.currentState == [OGSceneLoaderBeforePreloadState class])
//    {
//        [sceneLoader asynchronouslyPreloadResources];
//    }
}

- (void)transitionToSceneWithIdentifier:(NSUInteger)sceneIdentifier
{
//    OGSceneLoader *sceneLoader = [self sceneLoaderForIdentifier:sceneIdentifier];
//    
//    if (sceneLoader.stateMachine.currentState.class == [OGSceneLoaderPreloadSuccessfulState class])
//    {
//        [self presentSceneWithSceneLoader:sceneLoader];
//    }
//    else if (sceneLoader.stateMachine.currentState.class == [OGSceneLoaderBeforePreloadState class])
//    {
//        [sceneLoader loadResources];
//        
//        if (sceneLoader.stateMachine.currentState.class == [OGSceneLoaderPreloadSuccessfulState class])
//        {
//            [self presentSceneWithSceneLoader:sceneLoader];
//        }
//    }
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

- (void)presentSceneWithSceneLoader:(OGSceneLoader *)sceneLoader
{
    SKTransition *transition = [SKTransition fadeWithDuration:kOGSceneManagerTransitionTimeInterval];
    [self.view presentScene:sceneLoader.scene transition:transition];
}

- (void)transitionToInitialScene
{
    [self transitionToSceneWithIdentifier:kOGSceneManagerInitialSceneIdentifier];
}

@end
