//
//  GameViewController.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/27/16.
//  Copyright (c) 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameViewController.h"
#import "OGScenesController.h"

@interface OGGameViewController ()

@property (nonatomic, retain) OGScenesController *scenesController;

@end

@implementation OGGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    SKView *view = (SKView *) self.view;
    
    /* DEBUG OPTIONS */
    view.showsFPS = YES;
    view.showsNodeCount = YES;
    
    OGScenesController *scenesController = [[OGScenesController alloc] init];
    
    if (scenesController)
    {
        scenesController.view = view;
        [scenesController loadLevelMap];
        
        self.scenesController = scenesController;
        [self.scenesController loadInitialLevel];    
    }
    
    [scenesController release];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)didCallChangeScene
{
    
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
