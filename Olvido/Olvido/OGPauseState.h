//
//  OGPauseState.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/19/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

extern CGFloat const kOGGameSceneStatusBarDuration;

@interface OGPauseState : GKState

- (instancetype)initWithView:(SKView *)view;

- (void)pauseScene;
- (void)resumeScene;

@end
