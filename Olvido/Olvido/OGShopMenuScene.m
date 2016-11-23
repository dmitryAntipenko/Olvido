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
#import "OGMenuManager.h"

NSString *const kOGShopMenuSceneMapMenuButtonNodeName = @"MapMenuButton";

@implementation OGShopMenuScene

- (void)onButtonClick:(OGButtonNode *)button
{
    [super onButtonClick:button];
    
    if ([button.name isEqualToString:kOGShopMenuSceneMapMenuButtonNodeName])
    {
        [self.menuManager loadMenuWithName:kOGMapMenuName];
    }
}

@end
