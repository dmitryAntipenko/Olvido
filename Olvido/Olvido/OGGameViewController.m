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
    view.showsPhysics = YES;
    
    OGControlChoosingScene *controlChoosingScene = [[OGControlChoosingScene alloc] initWithSize:view.frame.size];
    
    controlChoosingScene.viewController = self;
    
    [view presentScene:controlChoosingScene];

    [controlChoosingScene release];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)startGame
{
    OGScenesController *scenesController = [[OGScenesController alloc] init];
    SKView *view = (SKView *) self.view;

    if (scenesController)
    {
        scenesController.view = view;
        scenesController.controlType = self.controlType;
        [scenesController loadLevelMap];

        self.scenesController = scenesController;
        [self.scenesController loadInitialLevel];
    }

    [scenesController release];
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
    [_controlType release];
    
    [super dealloc];
}

@end
