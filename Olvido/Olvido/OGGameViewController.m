//
//  GameViewController.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/27/16.
//  Copyright (c) 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameViewController.h"
#import "OGGame.h"
#import "OGMenuManager.h"

@interface OGGameViewController ()

@property (nonatomic, strong) OGGame *game;

@end

@implementation OGGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SKView *view = (SKView *) self.view;
    
    view.multipleTouchEnabled = YES;
    
    /* DEBUG OPTIONS */
    view.showsFPS = YES;
    view.showsNodeCount = YES;
    view.showsPhysics = YES;

    /* DEBUG OPTIONS */
    
    self.game = [[OGGame alloc] initWithView:view];    
    [self.game.menuManager loadMainMenu];
}

- (BOOL)shouldAutorotate
{
    return YES;
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

@end
