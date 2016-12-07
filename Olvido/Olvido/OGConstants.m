//
//  OGConstants.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGConstants.h"

NSString *const OGPortalNodeName = @"portal";
NSString *const OGPauseButtonName = @"pause";

CGFloat const OGGameSceneStatusBarHidingDistance = 100.0;
CGFloat const OGGameSceneStatusBarAlpha = 0.5;
CGFloat const OGGameSceneStatusBarPositionOffset = 10.0;
CGFloat const OGGameSceneStatusBarYOffset = 10.0;
CGFloat const OGGameSceneStatusBarDuration = 0.2;

NSString *const OGPropertyFileExtension = @"plist";
NSString *const OGSceneFileExtension = @"sks";
//NSString *const OGMainMenuSceneFileName = @"OGMainMenuScene";
//NSString *const OGMapMenuSceneFileName = @"OGMapMenuScene";
//NSString *const OGSettingsMenuSceneFileName = @"OGSettingsMenuScene";
//NSString *const OGShopMenuSceneFileName = @"OGShopMenuScene";

CGFloat const OGGameSceneScoreLabelYPosition = -13.0;

CGFloat const OGConstantsDefaultTransitionTimeDuration = 1.0;

NSString *const OGPlayerSpriteName = @"Player";
NSString *const OGEnemySpriteName = @"Enemy";
NSString *const OGPortalSpriteName = @"Door";
NSString *const OGObstacleSpriteName = @"Obstacle";

NSString *const OGMainMenuName = @"MainMenu";
NSString *const OGMapMenuName = @"MapMenu";
NSString *const OGSettingsMenuName = @"SettingsMenu";
NSString *const OGShopMenuName = @"ShopMenu";

NSString *const OGConstantsIdle = @"Idle";
NSString *const OGConstantsWalk = @"Walk";
NSString *const OGConstantsRun = @"Run";
NSString *const OGConstantsAttack = @"Attack";
NSString *const OGConstantsDead = @"Dead";

NSString *const OGConstantsLeft = @"Left";
NSString *const OGConstantsRight = @"Right";

NSString *const OGConstantsSceneConfigurationSuffix = @"_Configuration";

NSString *const OGConstantsSceneSuffixForIpadIdiom = @"_iPad";
NSString *const OGConstantsSceneSuffixForIphoneIdiom = @"_iPhone";
NSString *const OGConstantsSceneSuffixForUnspecifiedIdiom = @"";

@implementation OGConstants

+ (CGPoint)randomPointInRect:(CGRect)rect
{
    CGFloat maxX = rect.size.width;
    CGFloat minX = rect.origin.x;
    CGFloat maxY = rect.size.height;
    CGFloat minY = rect.origin.y;
    
    CGFloat x = rand() / (CGFloat) RAND_MAX * (maxX - minX) + minX;
    CGFloat y = rand() / (CGFloat) RAND_MAX * (maxY - minY) + minY;
    
    return CGPointMake(x, y);
}

+ (CGVector)randomVectorWithLength:(CGFloat)length
{
    CGFloat angle = (rand() / (CGFloat) RAND_MAX) * 2 * M_PI;
    
    return CGVectorMake(length * cosf(angle), length * sinf(angle));
}

+ (CGVector)randomVector
{
    CGFloat angle = (rand() / (CGFloat) RAND_MAX) * 2 * M_PI;
    
    return CGVectorMake(cosf(angle), sinf(angle));
}

+ (CGSize)thumbStickNodeSize
{
    return CGSizeMake(200.0, 200.0);
}

+ (CGFloat)thumbStickNodeRadius
{
    return [OGConstants thumbStickNodeSize].width / 2.0;
}

+ (NSString *)sceneSuffixForInterfaceIdiom:(UIUserInterfaceIdiom)idiom
{
    NSString *result = nil;
    
    if (idiom == UIUserInterfaceIdiomPad)
    {
        result = OGConstantsSceneSuffixForIpadIdiom;
    }
    else if (idiom == UIUserInterfaceIdiomPhone)
    {
        result = OGConstantsSceneSuffixForIphoneIdiom;
    }
    else if (idiom == UIUserInterfaceIdiomUnspecified)
    {
        result = OGConstantsSceneSuffixForUnspecifiedIdiom;
    }
    
    return result;
}

@end
