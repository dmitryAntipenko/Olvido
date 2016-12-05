//
//  OGGameSceneDelegate.h
//  Olvido
//
//  Created by Алексей Подолян on 11/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OGGameSceneDelegate <NSObject>

- (void)didCallPause;
- (void)didCallResume;

- (void)didCallExit;

- (void)didCallFinish;
- (void)didCallRestart;

@end
