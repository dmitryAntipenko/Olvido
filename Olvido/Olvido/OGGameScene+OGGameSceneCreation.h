//
//  OGGameScene+OGGameSceneCreation.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene.h"

extern NSString *const kOGGameSceneTimerCircleNodeName;
extern NSString *const kOGGameSceneBorderNodeName;
extern NSString *const kOGGameSceneBorderCropNodeName;

extern NSString *const kOGGameSceneRestartButtonSpriteName;

@interface OGGameScene (OGGameSceneCreation)

- (SKNode *)createBackground;
- (SKNode *)createMiddleGround;
- (SKNode *)createForeground;

- (SKNode *)createGameOverScreenWithScore:(NSNumber *)score;
- (SKNode *)createDimPanel;

@end
