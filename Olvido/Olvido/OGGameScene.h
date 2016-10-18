//
//  OGGameScene.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

@import SpriteKit;

#import "OGGameSceneDelegate.h"
#import "OGPortalLocation.h"
#import "SKColor+OGConstantColors.h"
#import "OGCollisionBitMask.h"
#import "OGConstants.h"

#import "OGEntity.h"
#import "OGVisualComponent.h"
#import "OGTransitionComponent.h"
#import "OGMovementComponent.h"
#import "OGMovementControlComponent.h"
#import "OGSpriteNode.h"

@class OGEntity;

@interface OGGameScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic, copy) NSString *controlType;

@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSNumber *enemiesCount;

@property (nonatomic, assign) OGMovementControlComponent *playerMovementControlComponent;

@property (nonatomic, retain) id <OGGameSceneDelegate> sceneDelegate;

@property (nonatomic, retain) OGEntity *player;
@property (nonatomic, retain, readonly) NSMutableArray<OGEntity *> *enemies;
@property (nonatomic, retain, readonly) NSMutableArray<OGEntity *> *portals;
@property (nonatomic, retain, readonly) NSMutableArray<OGEntity *> *coins;

- (void)createSceneContents;
- (void)createEnemies;
- (void)createPlayer;

- (void)addPortal:(OGEntity *)portal;

@end
