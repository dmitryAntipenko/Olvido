//
//  OGEnemyEntity.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

#import "OGContactNotifiableType.h"
#import "OGRulesComponentDelegate.h"
#import "OGHealthComponentDelegate.h"
#import "OGEntityManaging.h"

@class OGEnemyConfiguration;

@class OGRulesComponent;
@class OGRenderComponent;
@class OGOrientationComponent;
@class OGIntelligenceComponent;

typedef NS_ENUM(NSUInteger, OGEnemyEntityMandate)
{
    OGEnemyEntityMandateFollowPath = 0,
    OGEnemyEntityMandateHunt = 1,
    OGEnemyEntityMandateReturnToPositionOnPath = 2,
    OGEnemyEntityMandateCheckPoint = 3
};

extern NSTimeInterval const OGEnemyEntityMaxPredictionTimeForObstacleAvoidance;
extern NSTimeInterval const OGEnemyEntityBehaviorUpdateWaitDuration;

extern CGFloat const OGEnemyEntityThresholdProximityToPatrolPathStartPoint;
extern CGFloat const OGEnemyEntityPathfindingGraphBufferRadius;

extern NSUInteger const OGEnemyEntityDealDamage;

@interface OGEnemyEntity : GKEntity <GKAgentDelegate, OGRulesComponentDelegate, OGContactNotifiableType, OGHealthComponentDelegate>

@property (nonatomic, weak) id<OGEntityManaging> delegate;

@property (nonatomic, strong, readonly) OGEnemyConfiguration *enemyConfiguration;

@property (nonatomic, strong) OGRulesComponent *rulesComponent;
@property (nonatomic, strong, readonly) OGRenderComponent *renderComponent;
@property (nonatomic, strong, readonly) OGOrientationComponent *orientationComponent;
@property (nonatomic, strong, readonly) OGIntelligenceComponent *intelligenceComponent;
@property (nonatomic, strong) GKAgent2D *agent;
@property (nonatomic, weak, readonly) GKAgent2D *huntAgent;

@property (nonatomic, strong) GKGraph *graph;

@property (nonatomic, assign) OGEnemyEntityMandate mandate;

@property (nonatomic, assign) CGPoint closestPointOnPath;

- (instancetype)initWithConfiguration:(OGEnemyConfiguration *)configuration
                                graph:(GKGraph *)graph
                               states:(NSArray<GKState *> *)states NS_DESIGNATED_INITIALIZER;

- (GKBehavior *)behaviorForCurrentMandate;
- (void)entityDidDie;

- (CGPoint)closestPointOnPathWithGraph:(GKGraph *)graph;
- (CGFloat)closestDistanceToAgentWithGraph:(GKGraph *)graph;

- (CGFloat)distanceBetweenStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
- (CGFloat)distanceToAgentWithOtherAgent:(GKAgent2D *)otherAgent;

+ (void)loadMiscellaneousAssets;

@end
