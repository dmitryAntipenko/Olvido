//
//  OGSettingsMenuScene.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/27/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSettingsMenuScene.h"
#import "OGLevelManager.h"
#import "OGConstants.h"
#import "OGButtonNode.h"

NSString *const kOGSettingsMenuSceneMainMenuButtonNodeName = @"MainMenuButton";

@implementation OGSettingsMenuScene

- (void)didMoveToView:(SKView *)view
{
    self.scaleMode = SKSceneScaleModeAspectFit;
}

/* temporary code */
- (void)activateDrag
{
    [OGLevelManager sharedInstance].controlType = kOGLevelManagerDragControl;
}

- (void)activateTapContinue
{
    [OGLevelManager sharedInstance].controlType = kOGLevelManagerTapContinueControl;
}

- (void)activateTapStop
{
    [OGLevelManager sharedInstance].controlType = kOGLevelManagerTapStopControl;
}

- (void)changeGodMode
{
    [OGLevelManager sharedInstance].godMode = ![OGLevelManager sharedInstance].godMode;
}
/* temporary code */

- (void)onButtonClick:(OGButtonNode *)button
{
    NSString *sceneFilePath = nil;
    
    if ([button.name isEqualToString:kOGSettingsMenuSceneMainMenuButtonNodeName])
    {
        sceneFilePath = [[NSBundle mainBundle] pathForResource:kOGMainMenuSceneFileName ofType:kOGSceneFileExtension];
    }
    
    if (sceneFilePath)
    {
        SKScene *nextScene = [NSKeyedUnarchiver unarchiveObjectWithFile:sceneFilePath];
        
        if (nextScene)
        {
            [self.view presentScene:nextScene];
        }
    }
}

@end
