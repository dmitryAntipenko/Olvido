//
//  OGMapMenuScene.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTextureAtlasesManager.h"

#import "OGMapMenuScene.h"
#import "OGLevelManager.h"
#import "OGButtonNode.h"
#import "OGConstants.h"
#import "OGMenuManager.h"
#import "OGLevelManager.h"

NSString *const OGMapMenuSceneMainMenuButtonNodeName = @"MainMenuButton";
NSString *const OGMapMenuSceneShopButtonNodeName = @"ShopButton";

@implementation OGMapMenuScene

- (void)didMoveToView:(SKView *)view
{
    
}

- (void)startGame
{
    self.menuManager.levelManager.view = self.view;
    [self.menuManager.audioManager stopMusic];
    [self.menuManager.levelManager loadLevelWithIdentifier:@0];
}

- (void)onButtonClick:(OGButtonNode *)button
{
    [super onButtonClick:button];
    
    if ([button.name isEqualToString:OGMapMenuSceneMainMenuButtonNodeName])
    {
        [self.menuManager loadMenuWithName:OGMainMenuName];
    }
    else if ([button.name isEqualToString:OGMapMenuSceneShopButtonNodeName])
    {
        [self.menuManager loadMenuWithName:OGShopMenuName];
    }
}

@end
