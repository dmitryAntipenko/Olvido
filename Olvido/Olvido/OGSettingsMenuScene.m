//
//  OGSettingsMenuScene.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/27/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSettingsMenuScene.h"
#import "OGLevelController.h"
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
    [OGLevelController sharedInstance].controlType = kOGLevelControllerDragControl;
}

- (void)activateTapContinue
{
    [OGLevelController sharedInstance].controlType = kOGLevelControllerTapContinueControl;
}

- (void)activateTapStop
{
    [OGLevelController sharedInstance].controlType = kOGLevelControllerTapStopControl;
}

- (void)changeGodMode
{
    [OGLevelController sharedInstance].godMode = ![OGLevelController sharedInstance].godMode;
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
