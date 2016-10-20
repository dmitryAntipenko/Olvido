//
//  GameViewController.h
//  Olvido
//

//  Copyright (c) 2016 Дмитрий Антипенко. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

@interface OGGameViewController : UIViewController

@property (nonatomic, assign) GKStateMachine *uiStateMachine;

- (void)pause;

- (void)resume;

@end
