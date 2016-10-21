//
//  OGGameScene+OGGameSceneCreation.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene.h"

@interface OGGameScene (OGGameSceneCreation)

- (SKCropNode *)createBackgroundBorderWithColor:(SKColor *)color;

/* SCENE CONTENTS */

- (void)createSceneContents;
- (void)createEnemies;
- (void)createPlayer;
- (void)createPauseBar;

/* COMPONENTS */

- (void)createPortalAccessComponent;

- (void)addPortalToScene:(OGEntity *)portal;

@end
