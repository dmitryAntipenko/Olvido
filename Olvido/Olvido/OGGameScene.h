//
//  OGGameScene.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGGameSceneDelegate.h"
#import "OGBaseScene.h"
#import "OGTransitionComponentDelegate.h"

@class OGPlayerEntity;
@class OGMovementControlComponent;
@class OGTransitionComponent;
@class OGAccessComponent;
@class OGStatusBar;
@class OGHealthComponent;
@class OGInventoryComponent;
@class OGAnimationComponent;

@interface OGGameScene : OGBaseScene <SKPhysicsContactDelegate, OGTransitionComponentDelegate>

@property (nonatomic, copy) NSNumber *identifier;

@property (nonatomic, weak) id<OGGameSceneDelegate> sceneDelegate;

@property (nonatomic, strong) OGStatusBar *statusBar;

@property (nonatomic, strong) OGPlayerEntity *player;

- (void)pause;
- (void)restart;
- (void)resume;
- (void)pauseWithPauseScreen;
- (void)gameOver;

- (void)runStoryConclusion;

@end
