//
//  OGSettingsMenuScene.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/27/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSettingsMenuScene.h"
#import "OGLevelController.h"

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

@end
