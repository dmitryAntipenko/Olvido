//
//  OGPauseState.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/19/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPauseState.h"
#import "OGGameState.h"
#import "OGGameScene.h"
#import "OGGameScene+OGGameSceneCreation.h"

@interface OGPauseState ()

@property (nonatomic, retain) SKView *view;

@end

@implementation OGPauseState

- (instancetype)initWithView:(SKView *)view
{
    self = [super init];
    
    if (self)
    {
        _view = [view retain];
    }
    else
    {
        [self release];
        self  = nil;
    }
    
    return self;
}

- (void)dealloc
{
    [_view release];
    
    [super dealloc];
}

- (void)willExitWithNextState:(GKState *)nextState
{
    [self resumeScene];
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    if ([self.stateMachine canEnterState:[OGGameState class]])
    {
        
        OGGameScene *gameScene = (OGGameScene *) self.view.scene;
        gameScene.statusBar.position = CGPointMake(gameScene.statusBar.position.x,
                                                   self.view.scene.size.height + gameScene.statusBar.size.height);
        
        [self pauseScene];
        
        [gameScene createPauseBar];
    }
}

- (void)pauseScene
{
    [(OGGameScene *)self.view.scene pause];
}

- (void)resumeScene
{
    [(OGGameScene *)self.view.scene resume];
}

@end
