//
//  OGConstants.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#ifndef OGConstants_h
#define OGConstants_h

#import <SpriteKit/SpriteKit.h>

extern NSString *const OGPortalNodeName;

extern CGFloat const OGGameSceneStatusBarHidingDistance;
extern CGFloat const OGGameSceneStatusBarAlpha;
extern CGFloat const OGGameSceneStatusBarPositionOffset;
extern CGFloat const OGGameSceneStatusBarYOffset;
extern CGFloat const OGGameSceneStatusBarDuration;

extern NSString *const OGPropertyFileExtension;
extern NSString *const OGSceneFileExtension;

extern NSString *const OGPlayerSpriteName;
extern NSString *const OGPortalSpriteName;
extern NSString *const OGEnemySpriteName;
extern NSString *const OGObstacleSpriteName;

extern NSString *const OGMainMenuName;
extern NSString *const OGMapMenuName;
extern NSString *const OGSettingsMenuName;
extern NSString *const OGShopMenuName;

@interface OGConstants : NSObject

+ (CGPoint)randomPointInRect:(CGRect)rect;
+ (CGVector)randomVectorWithLength:(CGFloat)length;
+ (CGVector)randomVector;

+ (CGSize)thumbStickNodeSize;
+ (CGFloat)thumbStickNodeRadius;
@end

#endif /* OGConstants_h */
