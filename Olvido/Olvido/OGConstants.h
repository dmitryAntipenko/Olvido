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

extern NSString *const kOGPlayerNodeName;
extern NSString *const kOGEnemyNodeName;
extern NSString *const kOGObstacleNodeName;
extern NSString *const kOGCoinNodeName;
extern NSString *const kOGPortalNodeName;
extern NSString *const kOGPauseButtonName;

extern CGFloat const kOGGameSceneStatusBarHidingDistance;
extern CGFloat const kOGGameSceneStatusBarAlpha;
extern CGFloat const kOGGameSceneStatusBarPositionOffset;
extern CGFloat const kOGGameSceneStatusBarYOffset;
extern CGFloat const kOGGameSceneStatusBarDuration;

extern NSString *const kOGGameSceneResumeName;
extern NSString *const kOGGameSceneMenuName;
extern NSString *const kOGGameSceneRestartName;

extern NSString *const kOGEnemyTextureName;
extern NSString *const kOGPlayerTextureName;
extern NSString *const kOGCoinTextureName;
extern NSString *const kOGHorizontalPortalTextureName;
extern NSString *const kOGVerticalPortalTextureName;
extern NSString *const kOGStatusBarBackgroundTextureName;
extern NSString *const kOGPauseButtonTextureName;
extern NSString *const kOGResumeButtonTextureName;

extern CGFloat const kOGPlayerNodeInvulnerabilityRepeatCount;
extern CGFloat const kOGPlayerNodeInvulnerabilityBlinkingTimeDuration;

@interface OGConstants : NSObject

+ (CGPoint)randomPointInRect:(CGRect)rect;
+ (CGVector)randomVectorWithLength:(CGFloat)length;
+ (CGVector)randomVector;

@end

#endif /* OGConstants_h */
