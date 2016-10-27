//
//  OGMapMenuScene.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMapMenuScene.h"
#import "OGLevelController.h"

@implementation OGMapMenuScene

- (void)didMoveToView:(SKView *)view
{
    self.scaleMode = SKSceneScaleModeAspectFit;
}

- (void)startGame
{
    OGLevelController *levelController = [OGLevelController sharedInstance];
    levelController.view = self.view;
    [levelController loadLevelMap];
    [levelController loadLevelWithIdentifier:@0];
    
    [levelController runScene];
}

- (void)dealloc
{
    [super dealloc];
}

@end
