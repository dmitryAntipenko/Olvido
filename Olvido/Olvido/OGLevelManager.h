//
//  OGLevelManager.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class OGGameScene;
@class OGStoryScene;
@class OGSceneManager;

@interface OGLevelManager : NSObject

@property (nonatomic, weak) SKView *view;

@property (nonatomic, copy, readonly) NSArray *levelMap;
@property (nonatomic, strong) OGSceneManager *sceneManager;

+ (instancetype)levelManager;

- (void)loadLevelMap;
- (void)loadLevelWithIdentifier:(NSNumber *)identifier;

- (void)pause;
- (void)resume;

@end
