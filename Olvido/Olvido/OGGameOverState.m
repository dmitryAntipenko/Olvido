//
//  OGGameOverState.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/19/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameOverState.h"
#import "OGGameState.h"
#import "OGGameOverScene.h"

@implementation OGGameOverState

- (void)dealloc
{
    [_score release];
    [_controlType release];
    
    [super dealloc];
}


- (void)didEnterWithPreviousState:(GKState *)previousState
{
    if ([self.stateMachine canEnterState:[OGGameState class]])
    {
        OGGameOverScene *gameOverScene = [[OGGameOverScene alloc] initWithSize:self.view.frame.size];
        gameOverScene.score = self.score;
        gameOverScene.uiStateMachine = self.stateMachine;
        gameOverScene.godMode = self.godMode;
        gameOverScene.controlType = self.controlType;
        
        [self.view presentScene:gameOverScene];
        
        [gameOverScene release];
    }
}

@end
