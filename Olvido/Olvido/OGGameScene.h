//
//  OGGameScene.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGBaseScene.h"
#import "OGTransitionComponentDelegate.h"
#import "OGEntityManaging.h"
#import "OGGameSceneDelegate.h"
#import "OGInteractionsManaging.h"

@class OGEntitySnapshot;
@class OGAudioManager;
@class OGRoom;

extern NSString *const OGGameSceneRoomsNodeName;

@interface OGGameScene : OGBaseScene <SKPhysicsContactDelegate, OGTransitionComponentDelegate, OGEntityManaging, OGInteractionsManaging>

@property (nonatomic, copy) NSNumber *identifier;
@property (nonatomic, weak) id<OGGameSceneDelegate> sceneDelegate;
@property (nonatomic, strong) GKStateMachine *stateMachine;
@property (nonatomic, strong) OGAudioManager *audioManager;

@property (nonatomic, strong) GKObstacleGraph *obstaclesGraph;

@property (nonatomic, strong, readonly) NSArray<SKSpriteNode *> *obstacleSpriteNodes;
@property (nonatomic, strong, readonly) NSArray<GKPolygonObstacle *> *polygonObstacles;

@property (nonatomic, strong, readonly) NSArray<GKEntity *> *entities;
@property (nonatomic, strong, readonly) NSArray<OGRoom *> *rooms;

- (void)resume;
- (void)pauseWithoutPauseScreen;
- (void)showGameOverScreen;
- (void)runStoryConclusion;
- (void)showCompletionScreen;

- (OGRoom *)roomWithIdentifier:(NSString *)identifier;

- (OGEntitySnapshot *)entitySnapshotWithEntity:(GKEntity *)entity;

@end
