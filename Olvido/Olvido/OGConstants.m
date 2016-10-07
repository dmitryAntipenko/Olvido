//
//  OGConstants.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

CGFloat const kOGGameSceneScoreDefaultFontSize = 36.0;
CGFloat const kOGGameSceneBorderSize = 3.0;

CGFloat const kOGGameSceneTimerCircleRadiusFactor = 4.0;
CGFloat const kOGGameSceneTimerCircleLineWidth = 5.0;
CGFloat const kOGGameSceneTimerCircleRadius = 100.0;
CGFloat const kOGGameSceneTimerLabelScaleFactor = 500.0;

CGFloat const kOGGameSceneButtonsMargin = 20.0;
CGFloat const kOGGameSceneButtonsVerticalMargin = 40.0;
CGFloat const kOGGameSceneButtonWidth = 80.0;

CGFloat const kOGGameSceneGameOverScreenHeightFactor = 2.5;
CGFloat const kOGGameSceneGameOverButtonPositionFactor = 4.0;

NSString *const kOGGameSceneGameOverBackgroundSpriteName = @"GameOverBackground";
NSString *const kOGGameSceneMenuButtonSpriteName = @"MenuButton";
NSString *const kOGGameSceneRestartButtonSpriteName = @"RestartButton";

NSString *const kOGGameSceneTimerCircleNodeName = @"timerCircleNode";
NSString *const kOGGameSceneBorderNodeName = @"borderNode";
NSString *const kOGGameSceneTimerCircleCropNodeName = @"timerCircleCropNode";
NSString *const kOGGameSceneBorderCropNodeName = @"borderCropNode";

NSUInteger const kOGLevelControllerLevelChangeInterval = 10;

NSString *const kOGLevelControllerLevelNameFormat = @"Level%2@";
NSString *const kOGLevelControllerLevelExtension = @"plist";

NSString *const kOGLevelControllerColorsKey = @"Colors";
NSString *const kOGLevelControllerObstaclesKey = @"Obstacles";
NSString *const kOGLevelControllerEnemyCountKey = @"Enemy Count";
NSString *const kOGLevelControllerBackgroundColorKey = @"Background Color";
NSString *const kOGLevelControllerAccentColorKey = @"Accent Color";
NSString *const kOGLevelControllerPlayerColorKey = @"Player Color";
NSString *const kOGLevelControllerEnemyColorKey = @"Enemy Color";

NSString *const kOGLevelControllerOriginKey = @"Origin";
NSString *const kOGLevelControllerSizeKey = @"Size";
NSString *const kOGLevelControllerOriginXKey = @"X";
NSString *const kOGLevelControllerOriginYKey = @"Y";
NSString *const kOGLevelControllerSizeWidthKey = @"Width";
NSString *const kOGLevelControllerSizeHeightKey = @"Height";
NSString *const kOGLevelControllerObstacleColorKey = @"Color";

/* Player */

CGFloat const kOGPlayerNodeBorderLineWidth = 4.0;
CGFloat const kOGPlayerNodeInvulnerabilityRepeatCount = 4.0;
CGFloat const kOGPlayerNodeInvulnerabilityBlinkingTimeDuration = 0.2;
NSString *const kOGPlayerNodeSpriteImageName = @"PlayerBall";
CGFloat const kOGPlayerNodeSpeed = 300.0;
NSUInteger const kOGPlayerNodeDefaultPreviousPositionsBufferSize = 5;
NSString *const kOGPlayerNodeMoveToPointActionKey = @"movePlayerToPointActionKey";