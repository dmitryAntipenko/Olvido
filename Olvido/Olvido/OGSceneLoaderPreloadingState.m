//
//  OGSceneLoaderpreloadingState.m
//  Olvido
//
//  Created by Алексей Подолян on 11/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneLoaderPreloadingState.h"
#import "OGSceneLoaderPreloadSuccessfulState.h"
#import "OGSceneLoaderErrorState.h"

@implementation OGSceneLoaderPreloadingState

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;
    
    result = (stateClass == [OGSceneLoaderPreloadSuccessfulState class]);
    result = result || (stateClass == [OGSceneLoaderErrorState class]);
    
    return result;
}

@end
