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

@property (nonatomic, strong, readonly) NSArray<OGSpriteNode *> *spriteNodes;
@property (nonatomic, weak) id<OGGameSceneDelegate> sceneDelegate;

@property (nonatomic, strong) OGStatusBar *statusBar;
@property (nonatomic, strong) OGSpriteNode *playerNode;
@property (nonatomic, strong) OGSpriteNode *portalNode;

@property (nonatomic, strong) OGMovementControlComponent *playerControlComponent;
@property (nonatomic, strong, readonly) OGAnimationComponent *playerAnimationComponent;
@property (nonatomic, strong, readonly) OGTransitionComponent *transitionComponent;
@property (nonatomic, strong, readonly) OGAccessComponent *accessComponent;
@property (nonatomic, strong, readonly) OGHealthComponent *healthComponent;
@property (nonatomic, strong, readonly) OGInventoryComponent *inventoryComponent;

- (void)addSpriteNode:(OGSpriteNode *)spriteNode;

- (void)pause;
- (void)restart;
- (void)resume;
- (void)pauseWithPauseScreen;
- (void)gameOver;

- (void)runStoryConclusion;

@end
