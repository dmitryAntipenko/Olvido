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
@class OGAnimationComponent;

@interface OGGameScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic, copy) NSNumber *identifier;

@property (nonatomic, retain, readonly) NSArray<OGSpriteNode *> *spriteNodes;
@property (nonatomic, assign) id<OGGameSceneDelegate> sceneDelegate;

@property (nonatomic, retain) OGStatusBar *statusBar;
@property (nonatomic, retain) OGSpriteNode *playerNode;
@property (nonatomic, retain) OGSpriteNode *portalNode;

@property (nonatomic, retain) OGMovementControlComponent *playerControlComponent;
@property (nonatomic, retain, readonly) OGAnimationComponent *playerAnimationComponent;
@property (nonatomic, retain, readonly) OGTransitionComponent *transitionComponent;
@property (nonatomic, retain, readonly) OGAccessComponent *accessComponent;
@property (nonatomic, retain, readonly) OGHealthComponent *healthComponent;
@property (nonatomic, retain, readonly) OGInventoryComponent *inventoryComponent;

- (void)addSpriteNode:(OGSpriteNode *)spriteNode;

- (void)pause;
- (void)restart;
- (void)resume;
- (void)showPauseScreen;
- (void)gameOver;

- (void)runStoryConclusion;

@end
