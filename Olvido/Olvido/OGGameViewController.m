//
//  GameViewController.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/27/16.
//  Copyright (c) 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameViewController.h"
#import "OGMainMenuScene.h"
#import "OGConstants.h"

#import "OGGameScene.h"
#import "OGSpriteNode.h"

@interface OGGameViewController ()

//@property (nonatomic, retain) OGScenesController *scenesController;

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
    
//    NSString *pathForSceneFile = [[NSBundle mainBundle] pathForResource:kOGMainMenuSceneFileName ofType:kOGSceneFileExtension];
//    OGMainMenuScene *mainMenuScene = [NSKeyedUnarchiver unarchiveObjectWithFile:pathForSceneFile];

    GKScene *sceneFile = [GKScene sceneWithFileNamed:@"MyScene"];
    OGGameScene *scene = (OGGameScene *)sceneFile.rootNode;
    scene.scaleMode = SKSceneScaleModeAspectFit;
    
    for (GKEntity *entity in sceneFile.entities)
    {
        GKSKNodeComponent *nodeComponent = (GKSKNodeComponent *) [entity componentForClass:[GKSKNodeComponent class]];
        
        OGSpriteNode *spriteNode = (OGSpriteNode *) nodeComponent.node;
        spriteNode.entity = (OGEntity *) nodeComponent.entity;
        
        [scene addSpriteNode:spriteNode];
    }
    
    [view presentScene:scene];
    
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

- (void)dealloc
{    
    [super dealloc];
}

@end
