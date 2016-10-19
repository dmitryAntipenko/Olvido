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

@interface OGMainMenuState ()

@property (nonatomic, retain) SKView *view;
@property (nonatomic, retain) OGScenesController *scenesController;

@end


@implementation OGMainMenuState

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
    [_scenesController release];
    
    [super dealloc];
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return (stateClass == [OGGameState class]);
}

- (void)willExitWithNextState:(GKState *)nextState
{
    
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    if (!previousState)
    {
        OGControlChoosingScene *controlChoosingScene = [[OGControlChoosingScene alloc] initWithSize:self.view.frame.size];
        controlChoosingScene.uiStateMachine = self.stateMachine;
        
        [self.view presentScene:controlChoosingScene];
        
        [controlChoosingScene release];
    }
}

/* Temporary code */
- (void)startGameWithControlType:(NSString *)type godMode:(BOOL)mode
{
    OGScenesController *scenesController = [[OGScenesController alloc] init];
    SKView *view = self.view;
    
    if (scenesController)
    {
        scenesController.view = view;
        scenesController.controlType = type;
        scenesController.godMode = mode;
        scenesController.uiStateMachine = self.stateMachine;
        [scenesController loadLevelMap];
        
        self.scenesController = scenesController;
        [self.scenesController loadInitialLevel];
    }
    
    [scenesController release];
    
    [self.stateMachine enterState:[OGGameState class]];
}
/* Temporary code */

@end
