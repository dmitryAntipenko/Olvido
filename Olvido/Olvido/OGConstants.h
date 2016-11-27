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

extern NSString *const kOGPortalNodeName;

extern CGFloat const kOGGameSceneStatusBarHidingDistance;
extern CGFloat const kOGGameSceneStatusBarAlpha;
extern CGFloat const kOGGameSceneStatusBarPositionOffset;
extern CGFloat const kOGGameSceneStatusBarYOffset;
extern CGFloat const kOGGameSceneStatusBarDuration;

extern NSString *const kOGPropertyFileExtension;
extern NSString *const kOGSceneFileExtension;

extern NSString *const kOGPlayerSpriteName;
extern NSString *const kOGPortalSpriteName;
extern NSString *const kOGEnemySpriteName;
extern NSString *const kOGObstacleSpriteName;

extern NSString *const kOGMainMenuName;
extern NSString *const kOGMapMenuName;
extern NSString *const kOGSettingsMenuName;
extern NSString *const kOGShopMenuName;

extern NSString *const kOGConstantsIdle;
extern NSString *const kOGConstantsWalk;
extern NSString *const kOGConstantsIdle;
extern NSString *const kOGConstantsRun;
extern NSString *const kOGConstantsAttack;
extern NSString *const kOGConstantsDead;


extern NSString *const kOGConstantsLeft;
extern NSString *const kOGConstantsRight;

@interface OGConstants : NSObject

+ (CGPoint)randomPointInRect:(CGRect)rect;
+ (CGVector)randomVectorWithLength:(CGFloat)length;
+ (CGVector)randomVector;

+ (CGSize)thumbStickNodeSize;
+ (CGFloat)thumbStickNodeRadius;
@end

#endif /* OGConstants_h */
