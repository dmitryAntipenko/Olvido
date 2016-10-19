//
//  GameViewController.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/27/16.
//  Copyright (c) 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameViewController.h"
#import "OGScenesController.h"
#import "OGControlChoosingScene.h"

#import "OGMainMenuState.h"
#import "OGGameState.h"

@interface OGGameViewController ()

@property (nonatomic, retain) OGScenesController *scenesController;

@end

@implementation OGGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    SKView *view = (SKView *) self.view;
    
    view.multipleTouchEnabled = NO;
    
    /* DEBUG OPTIONS */
    view.showsFPS = YES;
    view.showsNodeCount = YES;
    
    
    OGMainMenuState *mainMenuState = [[OGMainMenuState alloc] initWithView:view];
    OGGameState *gameState = [[OGGameState alloc] init];
    
    
    GKStateMachine *uiStateMachine = [GKStateMachine stateMachineWithStates:@[mainMenuState, gameState]];
    [uiStateMachine enterState:[OGMainMenuState class]];
    
    [mainMenuState release];
    [gameState release];
    
    /* Should be uncommented after temporary code delete */
    
//    OGScenesController *scenesController = [[OGScenesController alloc] init];
//    
//    if (scenesController)
//    {
//        scenesController.view = view;
//        [scenesController loadLevelMap];
//        
//        self.scenesController = scenesController;
//        [self.scenesController loadInitialLevel];
//    }
//    
//    [scenesController release];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    else
    {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)dealloc
{
    [_scenesController release];
    
    [super dealloc];
}

@end
