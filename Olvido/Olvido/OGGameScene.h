//
//  OGGameScene.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGGameSceneDelegate.h"

@class OGSpriteNode;
@class OGMovementControlComponent;
@class OGTransitionComponent;
@class OGAccessComponent;
@class OGStatusBar;
@class OGHealthComponent;
@class OGInventoryComponent;

@interface OGGameScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic, copy) NSNumber *identifier;

@property (nonatomic, retain, readonly) NSArray<OGSpriteNode *> *spriteNodes;
@property (nonatomic, assign) id<OGGameSceneDelegate> sceneDelegate;

@property (nonatomic, retain) OGStatusBar *statusBar;

@property (nonatomic, retain) OGMovementControlComponent *playerControlComponent;
@property (nonatomic, retain) OGTransitionComponent *transitionComponent;
@property (nonatomic, retain) OGAccessComponent *accessComponent;
@property (nonatomic, retain) OGHealthComponent *healthComponent;
@property (nonatomic, retain) OGInventoryComponent *inventoryComponent;

- (void)addSpriteNode:(OGSpriteNode *)spriteNode;

- (void)pauseWithoutPauseScreen;
- (void)restart;
- (void)resume;
- (void)gameOver;
- (void)pauseAndShowPauseScreen;

- (void)runStoryConclusion;

@end
