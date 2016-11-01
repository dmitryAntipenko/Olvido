//
//  OGMapMenuScene.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMapMenuScene.h"
#import "OGLevelController.h"
#import "OGButtonNode.h"
#import "OGConstants.h"

NSString *const kOGMapMenuSceneMainMenuButtonNodeName = @"MainMenuButton";
NSString *const kOGMapMenuSceneShopButtonNodeName = @"ShopButton";

@implementation OGMapMenuScene

- (void)didMoveToView:(SKView *)view
{
    self.scaleMode = SKSceneScaleModeAspectFit;
}

- (void)startGame
{
    OGLevelController *levelController = [OGLevelController sharedInstance];
    levelController.view = self.view;
    [levelController loadLevelWithIdentifier:@0];
    
    [levelController runStoryScene];
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
            [self.view presentScene:nextScene];
        }
    }
}

@end
