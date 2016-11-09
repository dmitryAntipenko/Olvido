//
//  OGSceneLoaderBeforePreloadState.m
//  Olvido
//
//  Created by Алексей Подолян on 11/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneLoaderBeforePreloadState.h"
#import "OGSceneLoaderPreloadingState.h"
#import "OGSceneLoaderErrorState.h"

@implementation OGSceneLoaderBeforePreloadState

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;
    
    result = (stateClass == [OGSceneLoaderPreloadingState class]);
    result = result ||  (stateClass == [OGSceneLoaderErrorState class]);
    
    return result;
}

@end
