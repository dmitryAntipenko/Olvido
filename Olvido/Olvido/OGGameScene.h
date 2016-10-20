//
//  OGGameScene.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

@import SpriteKit;

#import "OGGameSceneDelegate.h"
#import "OGConstants.h"
#import "OGTimer.h"

#import "OGPortalLocation.h"
#import "SKColor+OGConstantColors.h"
#import "OGCollisionBitMask.h"
#import "OGConstants.h"
#import "OGContactType.h"

#import "OGEntity.h"
#import "OGVisualComponent.h"
#import "OGTransitionComponent.h"
#import "OGMovementComponent.h"
#import "OGMovementControlComponent.h"
#import "OGSpriteNode.h"
#import "OGDragMovementControlComponent.h"
#import "OGTapMovementControlComponent.h"
#import "OGScoreController.h"

extern CGFloat const kOGGameSceneStatusBarYOffset;
extern CGFloat const kOGGameSceneStatusBarDuration;
extern NSString *const kOGGameSceneResumeName;
extern NSString *const kOGGameSceneMenuName;
extern NSString *const kOGGameSceneRestartName;

@class OGEntity;
@class OGMovementControlComponent;

@interface OGGameScene : SKScene <SKPhysicsContactDelegate>

/* temporary code */
@property (nonatomic, copy) NSString *controlType;
@property (nonatomic, assign) BOOL godMode;
/* temporary code */

@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSNumber *enemiesCount;

@property (nonatomic, assign) OGMovementControlComponent *playerMovementControlComponent;
@property (nonatomic, assign) OGVisualComponent *playerVisualComponent;

@property (nonatomic, retain) id <OGGameSceneDelegate> sceneDelegate;

@property (nonatomic, retain) OGEntity *player;
@property (nonatomic, retain, readonly) NSArray<OGEntity *> *enemies;
@property (nonatomic, retain, readonly) NSArray<OGEntity *> *portals;
@property (nonatomic, retain, readonly) NSArray<OGEntity *> *coins;

@property (nonatomic, retain) SKSpriteNode *statusBar;
@property (nonatomic, assign) CGFloat statusBarMinDistance;
@property (nonatomic, retain) SKLabelNode *scoreLabel;
@property (nonatomic, retain) OGScoreController *scoreController;
@property (nonatomic, retain) OGTimer *scoreTimer;
@property (nonatomic, retain) OGTimer *coinsCreationTimer;

@property (nonatomic, retain) SKSpriteNode *pauseBarSprite;

- (void)addEnemy:(OGEntity *)enemy;
- (void)removeEnemy:(OGEntity *)enemy;

- (void)addCoin:(OGEntity *)coin;
- (void)removeCoin:(OGEntity *)coin;

- (void)addPortal:(OGEntity *)portal;
- (void)removePortal:(OGEntity *)portal;

- (void)changeStatusBarLocationWithY:(CGFloat)y;

@property (nonatomic, assign) OGPortalLocation exitPortalLocation;

- (void)pause;
- (void)resume;

@end
