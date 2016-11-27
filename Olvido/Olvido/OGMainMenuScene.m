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

NSString *const OGMainMenuSceneSettingsButtonNodeName = @"SettingsButton";
NSString *const OGMainMenuSceneMapMenuButtonNodeName = @"MapMenuButton";

@implementation OGMainMenuScene

- (void)onButtonClick:(OGButtonNode *)button
{
    [super onButtonClick:button];
    
    if ([button.name isEqualToString:OGMainMenuSceneSettingsButtonNodeName])
    {
        [self.menuManager loadMenuWithName:OGSettingsMenuName];
    }
    else if ([button.name isEqualToString:OGMainMenuSceneMapMenuButtonNodeName])
    {
        [self.menuManager loadMenuWithName:OGMapMenuName];
    }
}

@end
