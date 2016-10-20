//
//  OGMainMenu.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/19/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMainMenuState.h"
#import "OGGameState.h"
#import "OGControlChoosingScene.h"
#import "OGScenesController.h"
#import "OGGameOverState.h"

@implementation OGMainMenuState

- (BOOL)isValidNextState:(Class)stateClass
{
    return (stateClass == [OGGameState class]);
}

- (void)willExitWithNextState:(GKState *)nextState
{
    
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    OGControlChoosingScene *controlChoosingScene = [[OGControlChoosingScene alloc] initWithSize:self.view.frame.size];
    controlChoosingScene.uiStateMachine = self.stateMachine;
    
    [self.view presentScene:controlChoosingScene];
    
    [controlChoosingScene release];

}

/* Temporary code */
- (void)startGameWithControlType:(NSString *)type godMode:(BOOL)mode
{
    if ([self.stateMachine canEnterState:[OGGameState class]])
    {
        [self.stateMachine enterState:[OGGameState class]];
        
        OGScenesController *scenesController = [[OGScenesController alloc] init];
        SKView *view = self.view;
        
        if (scenesController)
        {
            scenesController.view = view;
            scenesController.controlType = type;
            scenesController.godMode = mode;
            scenesController.uiStateMachine = self.stateMachine;
            [scenesController loadLevelMap];
            
            ((OGGameOverState *) [self.stateMachine stateForClass:[OGGameOverState class]]).godMode = mode;
            ((OGGameOverState *) [self.stateMachine stateForClass:[OGGameOverState class]]).controlType = type;
            
            ((OGGameState *) self.stateMachine.currentState).scenesController = scenesController;
            [((OGGameState *) self.stateMachine.currentState).scenesController loadInitialLevel];
        }
        
        [scenesController release];
    }
}
/* Temporary code */

@end
