//
//  OGMainMenuScene.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMainMenuScene.h"
#import "OGButtonNode.h"
#import "OGConstants.h"

NSString *const kOGMainMenuSceneSettingsButtonNodeName = @"SettingsButton";
NSString *const kOGMainMenuSceneMapMenuButtonNodeName = @"MapMenuButton";

@implementation OGMainMenuScene

- (void)didMoveToView:(SKView *)view
{
    self.scaleMode = SKSceneScaleModeAspectFit;
}

- (void)onButtonClick:(OGButtonNode *)button
{
    NSString *sceneFilePath = nil;
    
    if ([button.name isEqualToString:kOGMainMenuSceneSettingsButtonNodeName])
    {
        sceneFilePath = [[NSBundle mainBundle] pathForResource:kOGSettingsMenuSceneFileName ofType:kOGSceneFileExtension];
    }
    else if ([button.name isEqualToString:kOGMainMenuSceneMapMenuButtonNodeName])
    {
        sceneFilePath = [[NSBundle mainBundle] pathForResource:kOGMapMenuSceneFileName ofType:kOGSceneFileExtension];
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
