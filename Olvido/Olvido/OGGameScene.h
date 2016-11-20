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

@class OGEntitySnapshot;

@protocol OGGameSceneDelegate <NSObject>

- (void)gameSceneDidCallFinish;
- (void)gameSceneDidCallRestart;

@end

@interface OGGameScene : OGBaseScene <SKPhysicsContactDelegate, OGTransitionComponentDelegate, OGEntityManaging>

@property (nonatomic, copy) NSNumber *identifier;
@property (nonatomic, weak) id<OGGameSceneDelegate> sceneDelegate;

@property (nonatomic, strong) GKObstacleGraph *obstaclesGraph;

@property (nonatomic, strong, readonly) NSArray<SKSpriteNode *> *obstacleSpriteNodes;
@property (nonatomic, strong, readonly) NSArray<GKPolygonObstacle *> *polygonObstacles;

@property (nonatomic, strong, readonly) NSArray<GKEntity *> *entities;

- (void)restart;

- (void)pauseWithPauseScreen;

- (void)gameOver;

- (void)runStoryConclusion;

- (OGEntitySnapshot *)entitySnapshotWithEntity:(GKEntity *)entity;

@end
