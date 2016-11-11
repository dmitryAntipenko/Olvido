//
//  OGShopScene.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/27/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGShopMenuScene.h"
#import "OGConstants.h"
#import "OGButtonNode.h"

NSString *const kOGShopMenuSceneMapMenuButtonNodeName = @"MapMenuButton";

@implementation OGShopMenuScene

- (void)onButtonClick:(OGButtonNode *)button
{
    NSString *sceneFilePath = nil;
    
    if ([button.name isEqualToString:kOGShopMenuSceneMapMenuButtonNodeName])
    {
        sceneFilePath = [[NSBundle mainBundle] pathForResource:kOGMapMenuSceneFileName ofType:kOGSceneFileExtension];
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
