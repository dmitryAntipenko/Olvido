 //
//  OGConstants.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGConstants.h"

NSString *const kOGObstacleNodeName = @"obstacle";
NSString *const kOGPortalNodeName = @"portal";
NSString *const kOGPauseButtonName = @"pause";

CGFloat const kOGGameSceneStatusBarHidingDistance = 100.0;
CGFloat const kOGGameSceneStatusBarAlpha = 0.5;
CGFloat const kOGGameSceneStatusBarPositionOffset = 10.0;
CGFloat const kOGGameSceneStatusBarYOffset = 10.0;
CGFloat const kOGGameSceneStatusBarDuration = 0.2;

NSString *const kOGSceneFileExtension = @"sks";
NSString *const kOGMainMenuSceneFileName = @"OGMainMenuScene";

CGFloat const kOGGameSceneScoreLabelYPosition = -13.0;

CGFloat const kOGConstantsDefaultTransitionTimeDuration = 1.0;

NSString *const kOGPlayerSpriteName = @"Player";
NSString *const kOGEnemySpriteName = @"Enemy";
NSString *const kOGPortalSpriteName = @"Door";

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

+ (SKTransition *)defaultTransion
{
    static SKTransition *transition;
    
    if (!transition)
    {
        transition = [SKTransition fadeWithDuration:kOGConstantsDefaultTransitionTimeDuration];
    }
    
    return transition;
}

@end
