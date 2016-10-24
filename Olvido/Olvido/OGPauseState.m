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

@implementation OGPauseState

- (void)willExitWithNextState:(GKState *)nextState
{
    if ([nextState isKindOfClass:[OGGameState class]])
    {
        [self resumeScene];
    }
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    if ([self.stateMachine canEnterState:[OGGameState class]])
    {
        OGGameScene *gameScene = (OGGameScene *) self.view.scene;
        
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
