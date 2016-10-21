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

@interface OGGameOverState ()

@property (nonatomic, retain) SKView *view;

@end

@implementation OGGameOverState

- (instancetype)initWithView:(SKView *)view
{
    self = [super init];
    
    if (self)
    {
        _view = [view retain];
    }
    
    return self;
}

- (void)dealloc
{
    [_view release];
    [_score release];
    
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
