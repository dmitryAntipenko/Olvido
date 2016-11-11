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
#import "OGMenuManager.h"

NSString *const kOGSettingsMenuSceneMainMenuButtonNodeName = @"MainMenuButton";

@implementation OGSettingsMenuScene

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
    if ([button.name isEqualToString:kOGSettingsMenuSceneMainMenuButtonNodeName])
    {
        [self.menuManager loadMenuWithName:kOGMainMenuName];
    }
}

@end
