//
//  OGLevelState.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLevelState.h"
#import "OGGameScene.h"

@implementation OGLevelState

- (instancetype)initWithLevelScene:(OGGameScene *)scene
{
    if (scene)
    {
        self = [self init];
        
        if (self)
        {
            _scene = scene;
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

+ (instancetype)stateWithLevelScene:(OGGameScene *)scene
{
    return [[self alloc] initWithLevelScene:scene];
}

@end
