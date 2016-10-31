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

@property (nonatomic, retain, readwrite) OGGameScene *scene;

@end

@implementation OGLevelState

- (instancetype)initWithLevelScene:(OGGameScene *)scene
{
    self = [self init];
    
    if (self)
    {
        _scene = [scene retain];
    }
    
    return self;
}

+ (instancetype)stateWithLevelScene:(OGGameScene *)scene
{
    return [[[OGLevelState alloc] initWithLevelScene:scene] autorelease];
}

- (void)dealloc
{
    [_scene release];
    
    [super dealloc];
}

@end
