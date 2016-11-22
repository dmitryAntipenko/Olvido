//
//  OGLevelManager.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGGameSceneDelegate.h"

@class OGGameScene;
@class OGStoryScene;
@class OGSceneManager;
@class OGMenuManager;

@interface OGLevelManager : NSObject <OGGameSceneDelegate>

@property (nonatomic, weak) SKView *view;

@property (nonatomic, copy, readonly) NSArray *levelMap;
@property (nonatomic, strong) OGSceneManager *sceneManager;
@property (nonatomic, weak) OGMenuManager *menuManager;

+ (instancetype)levelManager;

- (void)loadLevelMap;
- (void)loadLevelWithIdentifier:(NSNumber *)identifier;

@end
