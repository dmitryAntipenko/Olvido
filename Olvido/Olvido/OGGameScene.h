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

@property (nonatomic, retain) OGMovementControlComponent *playerControlComponent;
@property (nonatomic, retain) OGAnimationComponent *playerAnimationComponent;
@property (nonatomic, retain) OGTransitionComponent *transitionComponent;
@property (nonatomic, retain) OGAccessComponent *accessComponent;
@property (nonatomic, retain) OGHealthComponent *healthComponent;
@property (nonatomic, retain) OGInventoryComponent *inventoryComponent;

- (void)addSpriteNode:(OGSpriteNode *)spriteNode;

- (void)pause;
- (void)restart;
- (void)resume;
- (void)showPauseScreen;

- (void)runStoryConclusion;

@end
