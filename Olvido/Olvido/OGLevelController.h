//
//  OGLevelController.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class OGGameScene;
@class OGStoryScene;

/* temporary code */
extern NSString *const kOGLevelControllerDragControl;
extern NSString *const kOGLevelControllerTapContinueControl;
extern NSString *const kOGLevelControllerTapStopControl;
/* temporary code */

@interface OGLevelController : NSObject

@property (nonatomic, weak) SKView *view;

@property (nonatomic, copy, readonly) NSArray *levelMap;
@property (nonatomic, copy, readonly) NSString *currentSceneName;
@property (nonatomic, strong, readonly) OGGameScene *currentGameScene;
@property (nonatomic, strong, readonly) OGStoryScene *currentStoryScene;

/* temporary code */
@property (nonatomic, copy) NSString *controlType;
@property (nonatomic, assign) BOOL godMode;
/* temporary code */

+ (OGLevelController *)sharedInstance;

- (void)loadLevelMap;
- (void)loadLevelWithIdentifier:(NSNumber *)identifier;
- (void)runGameScene;
- (void)runStoryScene;

@end
