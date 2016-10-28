//
//  OGLevelController.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
@class OGGameScene;

/* temporary code */
extern NSString *const kOGLevelControllerDragControl;
extern NSString *const kOGLevelControllerTapContinueControl;
extern NSString *const kOGLevelControllerTapStopControl;
/* temporary code */

@interface OGLevelController : NSObject

@property (nonatomic, assign) SKView *view;

@property (nonatomic, copy, readonly) NSArray *levelMap;
@property (nonatomic, retain, readonly) OGGameScene *currentScene;

/* temporary code */
@property (nonatomic, copy) NSString *controlType;
@property (nonatomic, assign) BOOL godMode;
/* temporary code */

+ (OGLevelController *)sharedInstance;

- (void)loadLevelMap;
- (void)loadLevelWithIdentifier:(NSNumber *)identifier;
- (void)runScene;

@end
