//
//  OGSceneLoaderPreloadSuccessfulState.m
//  Olvido
//
//  Created by Алексей Подолян on 11/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneLoaderPreloadSuccessfulState.h"
#import "OGSceneLoaderBeforePreloadState.h"
#import "OGSceneLoaderErrorState.h"

@implementation OGSceneLoaderPreloadSuccessfulState

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;
    
    result = (stateClass == [OGSceneLoaderBeforePreloadState class]);
    
    return result;
}

@end
