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

@interface OGSceneLoaderPrepearingResourcesState ()

@property (nonatomic, weak) OGSceneLoader *sceneLoader;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSProgress *progress;

@end

@implementation OGSceneLoaderPrepearingResourcesState



- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;
    
    result = (stateClass == [OGSceneLoaderResourcesReadyState class]);
    result = result || (stateClass == [OGSceneLoaderResourcesReadyState class]);
    
    return result;
}

@end
