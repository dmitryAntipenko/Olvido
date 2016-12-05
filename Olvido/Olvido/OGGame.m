//
//  OGGame.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 12/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGame.h"
#import "OGAudioManager.h"
#import "OGMainMenuScene.h"
#import "OGConstants.h"
#import "OGLevelManager.h"
#import "OGSceneManager.h"
#import "OGGameScene.h"
#import "OGMenuManager.h"

@interface OGGame ()

@property (nonatomic, strong) OGSceneManager *sceneManager;
@property (nonatomic, strong) OGLevelManager *levelManager;
@property (nonatomic, strong) OGMenuManager *menuManager;
@property (nonatomic, strong) OGAudioManager *audioManager;

@end

@implementation OGGame

- (instancetype)initWithView:(SKView *)view
{
    if (view)
    {
        self = [super init];
        
        if (self)
        {
            _sceneManager = [OGSceneManager sceneManagerWithView:view];
            _audioManager = [OGAudioManager audioManager];
            
            _levelManager = [OGLevelManager levelManager];
            _levelManager.sceneManager = _sceneManager;
            _levelManager.audioManager = _audioManager;
            
            _menuManager = [OGMenuManager menuManager];
            _menuManager.sceneManager = _sceneManager;
            _menuManager.audioManager = _audioManager;
            
            _menuManager.levelManager = _levelManager;
            _levelManager.menuManager = _menuManager;            
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

@end
