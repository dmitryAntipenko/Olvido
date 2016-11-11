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

NSString *const kOGMapMenuSceneMainMenuButtonNodeName = @"MainMenuButton";
NSString *const kOGMapMenuSceneShopButtonNodeName = @"ShopButton";

@implementation OGMapMenuScene

- (void)startGame
{
    OGLevelManager *levelManager = [OGLevelManager sharedInstance];
    levelManager.view = self.view;
    [levelManager loadLevelWithIdentifier:@0];
    
    [levelManager runStoryScene];
}

- (void)onButtonClick:(OGButtonNode *)button
{
    NSString *sceneFilePath = nil;
    
    if ([button.name isEqualToString:kOGMapMenuSceneMainMenuButtonNodeName])
    {
        sceneFilePath = [[NSBundle mainBundle] pathForResource:kOGMainMenuSceneFileName ofType:kOGSceneFileExtension];
    }
    else if ([button.name isEqualToString:kOGMapMenuSceneShopButtonNodeName])
    {
        sceneFilePath = [[NSBundle mainBundle] pathForResource:kOGShopMenuSceneFileName ofType:kOGSceneFileExtension];
    }
    
    if (sceneFilePath)
    {
        SKScene *nextScene = [NSKeyedUnarchiver unarchiveObjectWithFile:sceneFilePath];
        
        if (nextScene)
        {
            nextScene.scaleMode = SKSceneScaleModeAspectFit;
            [self.view presentScene:nextScene];
        }
    }
}

@end
