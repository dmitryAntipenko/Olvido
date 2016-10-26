//
//  OGLevelState.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLevelState.h"
#import "OGGameScene.h"

@interface OGLevelState ()

@property (nonatomic, retain) OGGameScene *privateScene;

@end

@implementation OGLevelState

+ (instancetype)stateWithLevelScene:(OGGameScene *)scene
{
    OGLevelState *state = nil;
    
    if (scene)
    {
        state = [OGLevelState state];
        
        state.privateScene = scene;
    }
    
    return state;
}

- (OGGameScene *)scene
{
    return self.privateScene;
}

- (void)dealloc
{
    [_privateScene release];
    
    [super dealloc];
}

@end
