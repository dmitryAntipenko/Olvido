//
//  OGGameScene+OGGameSceneCreation.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene.h"

extern CGFloat const kOGGameSceneBorderSize;
extern NSString *const kOGGameSceneMenuButtonSpriteName;
extern NSString *const kOGGameSceneRestartButtonSpriteName;

@interface OGGameScene (OGGameSceneCreation)

- (SKNode *)createBackground;
- (SKNode *)createMiddleGround;
- (SKNode *)createForeground;

- (SKNode *)createGameOverScreenWithScore:(NSNumber *)score;
- (SKNode *)createDimPanel;

@end
