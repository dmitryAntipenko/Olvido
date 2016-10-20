//
//  OGPauseState.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/19/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGUIState.h"

extern CGFloat const kOGGameSceneStatusBarDuration;

@interface OGPauseState : OGUIState

- (void)pauseScene;
- (void)resumeScene;

@end
