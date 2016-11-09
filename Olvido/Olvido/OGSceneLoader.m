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

@interface OGSceneLoader ()

@property (nonatomic, strong, readwrite) OGBaseScene *scene;

@end

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
                                                                     [OGSceneLoaderInitialState state],
                                                                     [OGSceneLoaderPrepearingResourcesState state],
                                                                     [OGSceneLoaderResourcesReadyState state]
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
    return [[OGSceneLoader alloc] initWithMetadata:metadata];
}

- (void)asynchronouslyLoadSceneForPresentation;
{
//    [self.stateMachine enterState:[OGSceneLoader class]];
//    
//    if (self.stateMachine.currentState.class == [OGSceneLoaderBeforePreloadState class])
//    {
//        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0x0), ^
//                       {
//                           NSString *path = [[NSBundle mainBundle] pathForResource:self.metadata.name ofType:kOGSceneFileExtension];
//                           self.scene = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//                           
//                           if (self.scene)
//                           {
//                               dispatch_async(dispatch_get_main_queue(), ^
//                                              {
//                                                  [self preloadingSuccessful];
//                                              });
//                           }
//                           else
//                           {
//                               dispatch_async(dispatch_get_main_queue(), ^
//                                              {
//                                                  [self preloadingFailure];
//                                              });
//                           }
//                       });
//    }
}

- (void)loadResources
{
//    [self.stateMachine enterState:[OGSceneLoaderPreloadingState class]];
//    
//    NSString *path = [[NSBundle mainBundle] pathForResource:self.metadata.name ofType:kOGSceneFileExtension];
//    self.scene = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//    
//    if (self.scene)
//    {
//        [self preloadingSuccessful];
//    }
//    else
//    {
//        [self preloadingFailure];
//    }
}

//- (void)preloadingSuccessful
//{
//    [self.stateMachine enterState:[OGSceneLoaderPreloadSuccessfulState class]];
//}
//
//- (void)preloadingFailure
//{
//    [self.stateMachine enterState:[OGSceneLoaderErrorState class]];
//}

- (void)purgeResources
{
    if (self.scene && !self.scene.view)
    {
        self.scene = nil;
    }
}

@end
