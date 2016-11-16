//
//  OGEnemyEntity.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGContactNotifiableType.h"
#import "OGResourceLoadable.h"

@class OGEnemyConfiguration;
@class OGHealthComponent;
@class OGAnimationComponent;
@class OGIntelligenceComponent;
@class OGRenderComponent;
@class OGMovementComponent;
@class OGPhysicsComponent;
@class OGOrientationComponent;

typedef NS_ENUM(NSUInteger, OGEnemyEntityMandate)
{
    kOGEnemyEntityMandateFollowPath = 0,
    kOGEnemyEntityMandateHunt,
    kOGEnemyEntityMandateAttack,
    kOGEnemyEntityMandateReturnToPositionOnPath
};

extern CGFloat const kOGEnemyEntityPathfindingGraphBufferRadius;
extern NSTimeInterval const kOGEnemyEntityMaxPredictionTimeForObstacleAvoidance;
extern NSTimeInterval const kOGEnemyEntityBehaviorUpdateWaitDuration;
extern CGFloat const kOGEnemyEntityThresholdProximityToPatrolPathStartPoint;

@interface OGEnemyEntity : GKEntity <OGResourceLoadable, OGContactNotifiableType, GKAgentDelegate>

@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;
@property (nonatomic, strong) OGHealthComponent *healthComponent;
@property (nonatomic, strong) OGAnimationComponent *animationComponent;
@property (nonatomic, strong) OGMovementComponent *movementComponent;
@property (nonatomic, strong) OGIntelligenceComponent *intelligenceComponent;
@property (nonatomic, strong) OGOrientationComponent *orientationComponent;

@property (nonatomic, strong) GKAgent2D *agent;
@property (nonatomic, strong) GKGraph *graph;

@property (nonatomic, assign) OGEnemyEntityMandate mandate;

+ (NSDictionary *)sOGEnemyEntityAnimations;

- (CGFloat)distanceToAgentWithOtherAgent:(GKAgent2D *)otherAgent;
- (GKBehavior *)behaviorForCurrentMandate;

- (instancetype)initWithConfiguration:(OGEnemyConfiguration *)configuration
                                graph:(GKGraph *)graph NS_DESIGNATED_INITIALIZER;

- (CGPoint)closestPointOnPathWithGraph:(GKGraph *)graph;
- (CGFloat)distanceBetweenStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
- (CGFloat)closestDistanceToAgentWithGraph:(GKGraph *)graph;

@end
