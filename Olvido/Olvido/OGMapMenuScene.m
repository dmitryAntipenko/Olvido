//
//  OGMapMenuScene.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMapMenuScene.h"
#import "OGLevelManager.h"
#import "OGButtonNode.h"
#import "OGConstants.h"
#import "OGMenuManager.h"
#import "OGLevelManager.h"

NSString *const kOGMapMenuSceneMainMenuButtonNodeName = @"MainMenuButton";
NSString *const kOGMapMenuSceneShopButtonNodeName = @"ShopButton";

@implementation OGMapMenuScene

- (void)startGame
{
    self.menuManager.levelManager.view = self.view;
    [self.menuManager.audioManager stopMusic];
    [self.menuManager.levelManager loadLevelWithIdentifier:@0];
}

- (void)onButtonClick:(OGButtonNode *)button
{
    [super onButtonClick:button];
    
    if ([button.name isEqualToString:kOGMapMenuSceneMainMenuButtonNodeName])
    {
        [self.menuManager loadMenuWithName:kOGMainMenuName];
    }
    else if ([button.name isEqualToString:kOGMapMenuSceneShopButtonNodeName])
    {
        [self.menuManager loadMenuWithName:kOGShopMenuName];
    }
}

@end
