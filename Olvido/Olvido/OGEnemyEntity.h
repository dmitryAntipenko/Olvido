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

@class OGEnemyConfiguration;

@class OGRulesComponent;
@class OGRenderComponent;
@class OGPhysicsComponent;
@class OGOrientationComponent;
@class OGAnimationComponent;
@class OGHealthComponent;

typedef NS_ENUM(NSUInteger, OGEnemyEntityMandate)
{
    kOGEnemyEntityMandateFollowPath = 0,
    kOGEnemyEntityMandateHunt,
    kOGEnemyEntityMandateReturnToPositionOnPath
};

extern NSTimeInterval const kOGEnemyEntityMaxPredictionTimeForObstacleAvoidance;
extern NSTimeInterval const kOGEnemyEntityBehaviorUpdateWaitDuration;

extern CGFloat const kOGEnemyEntityThresholdProximityToPatrolPathStartPoint;
extern CGFloat const kOGEnemyEntityPathfindingGraphBufferRadius;

extern NSUInteger const kOGEnemyEntityDealGamage;

extern NSString *const kOGEnemyEntityConfigurationPhysicsBodyRadiusKey;

@interface OGEnemyEntity : GKEntity <GKAgentDelegate, OGRulesComponentDelegate, OGContactNotifiableType, OGHealthComponentDelegate>

@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;
@property (nonatomic, strong) OGHealthComponent *healthComponent;
@property (nonatomic, strong) OGAnimationComponent *animationComponent;
@property (nonatomic, strong) OGOrientationComponent *orientationComponent;

@property (nonatomic, strong) OGRulesComponent *rulesComponent;
@property (nonatomic, strong) GKAgent2D *agent;
@property (nonatomic, weak, readonly) GKAgent2D *huntAgent;

@property (nonatomic, strong) GKGraph *graph;

@property (nonatomic, assign) OGEnemyEntityMandate mandate;

@property (nonatomic, assign) CGPoint closestPointOnPath;

- (instancetype)initWithConfiguration:(NSDictionary *)configuration
                                graph:(GKGraph *)graph NS_DESIGNATED_INITIALIZER;

- (GKBehavior *)behaviorForCurrentMandate;

- (CGPoint)closestPointOnPathWithGraph:(GKGraph *)graph;
- (CGFloat)closestDistanceToAgentWithGraph:(GKGraph *)graph;

- (CGFloat)distanceBetweenStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
- (CGFloat)distanceToAgentWithOtherAgent:(GKAgent2D *)otherAgent;

+ (void)loadMiscellaneousAssets;

@end
