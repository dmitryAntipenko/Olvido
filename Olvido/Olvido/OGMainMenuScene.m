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
#import "OGMenuManager.h"

NSString *const kOGMainMenuSceneSettingsButtonNodeName = @"SettingsButton";
NSString *const kOGMainMenuSceneMapMenuButtonNodeName = @"MapMenuButton";

@implementation OGMainMenuScene

- (void)onButtonClick:(OGButtonNode *)button
{
    if ([button.name isEqualToString:kOGMainMenuSceneSettingsButtonNodeName])
    {
        [self.menuManager loadMenuWithName:kOGSettingsMenuName];
    }
    else if ([button.name isEqualToString:kOGMainMenuSceneMapMenuButtonNodeName])
    {
        [self.menuManager loadMenuWithName:kOGMapMenuName];
    }
}

@end
