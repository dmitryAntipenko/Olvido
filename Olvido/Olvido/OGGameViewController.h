//
//  GameViewController.h
//  Olvido
//

//  Copyright (c) 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class OGSceneManager;
@class OGLevelManager;
@class OGMenuManager;

@interface OGGameViewController : UIViewController

@property (nonatomic, strong) OGSceneManager *sceneManager;
@property (nonatomic, strong) OGLevelManager *levelManager;
@property (nonatomic, strong) OGMenuManager *menuManager;

@end
