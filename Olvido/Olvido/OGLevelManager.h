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

/* temporary code */
extern NSString *const kOGLevelManagerDragControl;
extern NSString *const kOGLevelManagerTapContinueControl;
extern NSString *const kOGLevelManagerTapStopControl;
/* temporary code */

@interface OGLevelManager : NSObject

@property (nonatomic, weak) SKView *view;

@property (nonatomic, copy, readonly) NSArray *levelMap;
@property (nonatomic, copy, readonly) NSString *currentSceneName;
@property (nonatomic, strong, readonly) OGGameScene *currentGameScene;
@property (nonatomic, strong, readonly) OGStoryScene *currentStoryScene;
@property (nonatomic, strong) OGSceneManager *sceneManager;

/* temporary code */
@property (nonatomic, copy) NSString *controlType;
@property (nonatomic, assign) BOOL godMode;
/* temporary code */

+ (OGLevelManager *)sharedInstance;

- (void)loadLevelMap;
- (void)loadLevelWithIdentifier:(NSNumber *)identifier;
- (void)runGameScene;
- (void)runStoryScene;

@end
