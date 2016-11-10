//
//  OGSceneLoaderState.m
//  Olvido
//
//  Created by Алексей Подолян on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneLoaderState.h"

@implementation OGSceneLoaderState

+ (instancetype)stateWithSceneLoader:(OGSceneLoader *)sceneLoader
{
    return [[self alloc] initWithSceneLoader:sceneLoader];
}

- (instancetype)initWithSceneLoader:(OGSceneLoader *)sceneLoader
{
    if (sceneLoader)
    {
        self = [self init];
        
        if (self)
        {
            _sceneLoader = sceneLoader;
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

@end
