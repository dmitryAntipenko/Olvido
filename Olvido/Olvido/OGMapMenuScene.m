//
//  OGMapMenuScene.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMapMenuScene.h"
#import "OGScenesController.h"

@interface OGMapMenuScene ()

@property (nonatomic, retain) OGScenesController *scenesController;

@end

@implementation OGMapMenuScene

- (void)didMoveToView:(SKView *)view
{
    self.scaleMode = SKSceneScaleModeFill;
}

- (void)startGame
{
    OGScenesController *scenesController = [[OGScenesController alloc] init];
    scenesController.view = self.view;
    
    self.scenesController = scenesController;
    [self.scenesController loadLevelMap];
    [self.scenesController loadLevelWithIdentifier:@0];
    
    [self.scenesController runScene];
    
    //memory leak
    //[scenesController release];
}

- (void)dealloc
{
    [_scenesController release];
    
    [super dealloc];
}

@end
