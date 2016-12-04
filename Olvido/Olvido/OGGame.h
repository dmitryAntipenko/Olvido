//
//  OGGame.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 12/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class OGSceneManager;
@class OGLevelManager;
@class OGMenuManager;
@class OGAudioManager;

@interface OGGame : NSObject

@property (nonatomic, strong, readonly) OGSceneManager *sceneManager;
@property (nonatomic, strong, readonly) OGLevelManager *levelManager;
@property (nonatomic, strong, readonly) OGMenuManager *menuManager;
@property (nonatomic, strong, readonly) OGAudioManager *audioManager;

- (instancetype)initWithView:(SKView *)view;

@end
