//
//  GameViewController.h
//  Olvido
//

//  Copyright (c) 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class OGGame;

@interface OGGameViewController : UIViewController

@property (nonatomic, strong, readonly) OGGame *game;

@end
