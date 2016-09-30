//
//  OGGameScene+OGGameSceneCreation.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene.h"

extern NSUInteger const kOGGameSceneBorderSize;

@interface OGGameScene (OGGameSceneCreation)

- (SKNode *)createBackground;
- (SKNode *)createForeground;

@end
