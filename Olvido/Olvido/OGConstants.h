//
//  OGConstants.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#ifndef OGConstants_h
#define OGConstants_h

/* Game Scene Creation */

extern CGFloat const kOGGameSceneScoreDefaultFontSize;
extern CGFloat const kOGGameSceneBorderSize;

extern CGFloat const kOGGameSceneTimerCircleRadiusFactor;
extern CGFloat const kOGGameSceneTimerCircleLineWidth;
extern CGFloat const kOGGameSceneTimerCircleRadius;
extern CGFloat const kOGGameSceneTimerLabelScaleFactor;

extern CGFloat const kOGGameSceneButtonsMargin;
extern CGFloat const kOGGameSceneButtonsVerticalMargin;
extern CGFloat const kOGGameSceneButtonWidth;

extern CGFloat const kOGGameSceneGameOverScreenHeightFactor;
extern CGFloat const kOGGameSceneGameOverButtonPositionFactor;

extern NSString *const kOGGameSceneGameOverBackgroundSpriteName;
extern NSString *const kOGGameSceneMenuButtonSpriteName;
extern NSString *const kOGGameSceneRestartButtonSpriteName;

extern NSString *const kOGGameSceneTimerCircleNodeName;
extern NSString *const kOGGameSceneBorderNodeName;
extern NSString *const kOGGameSceneTimerCircleCropNodeName;
extern NSString *const kOGGameSceneBorderCropNodeName;

/* Level Controller */

extern NSUInteger const kOGLevelControllerLevelChangeInterval;

extern NSString *const kOGLevelControllerLevelNameFormat;
extern NSString *const kOGLevelControllerLevelExtension;

extern NSString *const kOGLevelControllerColorsKey;
extern NSString *const kOGLevelControllerObstaclesKey;
extern NSString *const kOGLevelControllerEnemyCountKey;
extern NSString *const kOGLevelControllerBackgroundColorKey;
extern NSString *const kOGLevelControllerAccentColorKey;
extern NSString *const kOGLevelControllerPlayerColorKey;
extern NSString *const kOGLevelControllerEnemyColorKey;

extern NSString *const kOGLevelControllerOriginKey;
extern NSString *const kOGLevelControllerOriginXKey;
extern NSString *const kOGLevelControllerOriginYKey;
extern NSString *const kOGLevelControllerPointsKey;
extern NSString *const kOGLevelControllerPointXKey;
extern NSString *const kOGLevelControllerPointYKey;
extern NSString *const kOGLevelControllerSizeHeightKey;
extern NSString *const kOGLevelControllerObstacleColorKey;

/* Player */

extern CGFloat const kOGPlayerNodeBorderLineWidth;
extern CGFloat const kOGPlayerNodeInvulnerabilityRepeatCount;
extern CGFloat const kOGPlayerNodeInvulnerabilityBlinkingTimeDuration;
extern NSString *const kOGPlayerNodeSpriteImageName;
extern CGFloat const kOGPlayerNodeSpeed;
extern NSUInteger const kOGPlayerNodeDefaultPreviousPositionsBufferSize;
extern NSString *const kOGPlayerNodeMoveToPointActionKey;

#endif /* OGConstants_h */
