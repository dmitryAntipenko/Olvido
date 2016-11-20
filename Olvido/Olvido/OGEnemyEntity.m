//
//  OGEnemyEntity.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyEntity.h"
#import "OGEnemyEntity+OGEnemyEntityResources.h"
#import "OGEnemyConfiguration.h"

#import "OGRenderComponent.h"
#import "OGIntelligenceComponent.h"
#import "OGMovementComponent.h"
#import "OGAnimationComponent.h"
#import "OGPhysicsComponent.h"
#import "OGRulesComponent.h"
#import "OGAttacking.h"
#import "OGEnemyBehavior.h"
#import "OGOrientationComponent.h"
#import "OGHealthComponent.h"

#import "OGEnemyEntityAgentControlledState.h"
#import "OGEnemyEntityPreAttackState.h"
#import "OGEnemyEntityAttackState.h"

#import "OGEntitySnapshot.h"
#import "OGEntityDistance.h"

#import "OGPlayerNearRule.h"
#import "OGPlayerMediumRule.h"
#import "OGPlayerFarRule.h"

#import "OGPlayerEntity.h"

#import "OGRulesComponentDelegate.h"
#import "OGHealthComponentDelegate.h"
#import "OGContactNotifiableType.h"

NSTimeInterval const kOGEnemyEntityMaxPredictionTimeForObstacleAvoidance = 1.0;
NSTimeInterval const kOGEnemyEntityBehaviorUpdateWaitDuration = 0.25;
NSTimeInterval const kOGEnemyEntityDelayBetweenAttacks = 1.0;

CGFloat const kOGEnemyEntityPathfindingGraphBufferRadius = 30.0;
CGFloat const kOGEnemyEntityPatrolPathRadius = 10.0;
CGFloat const kOGEnemyEntityWalkMaxSpeed = 50;
CGFloat const kOGEnemyEntityHuntMaxSpeed = 500;
CGFloat const kOGEnemyEntityMaximumAcceleration = 300.0;
CGFloat const kOGEnemyEntityAgentMass = 0.25;
CGFloat const kOGEnemyEntityThresholdProximityToPatrolPathStartPoint = 50.0;

NSUInteger const kOGEnemyEntityDealGamage = 1.0;

@interface OGEnemyEntity () <OGContactNotifiableType, OGRulesComponentDelegate, OGHealthComponentDelegate, GKAgentDelegate>

@property (nonatomic, strong) GKBehavior *behaviorForCurrentMandate;
@property (nonatomic, assign, readonly) CGPoint agentOffset;
@property (nonatomic, assign) CGFloat lastPositionX;
@property (nonatomic, weak, readwrite) GKAgent2D *huntAgent;

@end

@implementation OGEnemyEntity

#pragma mark - Inits
- (instancetype)init
{
    return [self initWithConfiguration:nil graph:nil];
}

- (instancetype)initWithConfiguration:(OGEnemyConfiguration *)configuration
                                graph:(GKGraph *)graph
{
    self = [super init];
    
    if (self)
    {
        _graph = graph;
        
        CGPoint position = CGPointMake(((GKGraphNode2D *) [graph nodes][0]).position.x, ((GKGraphNode2D *) [graph nodes][0]).position.y);
        
        _renderComponent = [[OGRenderComponent alloc] init];
        
        _renderComponent.node.position = position;
        
        [self addComponent:_renderComponent];

        _physicsComponent = [[OGPhysicsComponent alloc] initWithPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:configuration.physicsBodyRadius]
                                                               colliderType:[OGColliderType enemy]];
        [self addComponent:_physicsComponent];
        
        _healthComponent = [[OGHealthComponent alloc] init];
        _healthComponent.maxHealth = 10.0;
        _healthComponent.currentHealth = 10.0;
        
        [self addComponent:_healthComponent];
        
        _orientationComponent = [[OGOrientationComponent alloc] init];
        [self addComponent:_orientationComponent];
        
        _mandate = kOGEnemyEntityMandateFollowPath;
        
        _renderComponent.node.physicsBody = _physicsComponent.physicsBody;
        _renderComponent.node.physicsBody.allowsRotation = NO;
        
        _agent = [[GKAgent2D alloc] init];
        _agent.delegate = self;
        _agent.position = (vector_float2){_renderComponent.node.position.x, _renderComponent.node.position.y};
        _agent.maxSpeed = kOGEnemyEntityWalkMaxSpeed;
        _agent.maxAcceleration = kOGEnemyEntityMaximumAcceleration;
        _agent.mass = kOGEnemyEntityAgentMass;
        _agent.radius = configuration.physicsBodyRadius;
        _agent.behavior = [[GKBehavior alloc] init];
        [self addComponent:_agent];
        
        OGEnemyEntityAgentControlledState *agentControlledState = [[OGEnemyEntityAgentControlledState alloc] initWithEnemyEntity:self];
        OGEnemyEntityPreAttackState *preAttackState = [[OGEnemyEntityPreAttackState alloc] initWithEnemyEntity:self];
        OGEnemyEntityAttackState *attackState = [[OGEnemyEntityAttackState alloc] initWithEnemyEntity:self];

        _intelligenceComponent = [[OGIntelligenceComponent alloc] initWithStates:@[agentControlledState, preAttackState, attackState]];
        [self addComponent:_intelligenceComponent];

        _animationComponent = [[OGAnimationComponent alloc] initWithAnimations:[OGEnemyEntity sOGEnemyEntityAnimations]];
        [self addComponent:_animationComponent];

        [_renderComponent.node addChild:_animationComponent.spriteNode];
        
        _lastPositionX = _renderComponent.node.position.x;
        
        OGPlayerNearRule *playerNearRule = [[OGPlayerNearRule alloc] init];
        OGPlayerMediumRule *playerMediumRule = [[OGPlayerMediumRule alloc] init];
        OGPlayerFarRule *playerFarRule = [[OGPlayerFarRule alloc] init];
        
        _rulesComponent = [[OGRulesComponent alloc] initWithRules:@[playerNearRule, playerMediumRule, playerFarRule]];
        [self addComponent:_rulesComponent];
        _rulesComponent.delegate = self;
    }
    
    return self;
}

#pragma mark - OGHealthComponentDelegate Protocol Methods
- (void)entityWillDie
{
    [self removeComponentForClass:self.agent.class];
}

#pragma mark - GKAgentDelegate Protocol Methods
- (void)agentWillUpdate:(GKAgent *)agent
{
    [self updateAgentPositionToMatchNodePosition];
}

- (void)agentDidUpdate:(GKAgent *)agent
{
    if (self.intelligenceComponent && self.orientationComponent)
    {
        if ([self.intelligenceComponent.stateMachine.currentState isMemberOfClass:OGEnemyEntityAgentControlledState.self])
        {
            if (self.mandate == kOGEnemyEntityMandateHunt)
            {
                self.animationComponent.requestedAnimationState = kOGAnimationStateRun;
                self.agent.maxSpeed = kOGEnemyEntityHuntMaxSpeed;
            }
            else
            {
                self.animationComponent.requestedAnimationState = kOGAnimationStateWalkForward;
                self.agent.maxSpeed = kOGEnemyEntityWalkMaxSpeed;
            }
            
            [self updateNodePositionToMatchAgentPosition];
        }
        else
        {
            [self updateAgentPositionToMatchNodePosition];
        }
        
        if (_renderComponent.node.position.x != self.lastPositionX)
        {
            CGFloat differenceX = self.lastPositionX - _renderComponent.node.position.x;
            self.orientationComponent.direction = [OGOrientationComponent directionWithVectorX:differenceX];
            
            self.lastPositionX = _renderComponent.node.position.x;
        }
    }
}

#pragma mark - OGContactNotifiableType Protocol Methods
- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    
}

#pragma mark - OGRulesComponentDelegate Protocol Methods
- (void)rulesComponentWithRulesComponent:(OGRulesComponent *)rulesComponent ruleSystem:(GKRuleSystem *)ruleSystem
{
    OGEntitySnapshot *state = ruleSystem.state[kOGRulesComponentRuleSystemStateSnapshot];
    
    NSArray<NSNumber *> *huntNearPlayerRawMinimumGradeForFacts = [NSArray arrayWithObject:@(kOGFuzzyEnemyRuleFactPlayerNear)];
    
    NSArray<NSNumber *> *huntPlayerRaw = [NSArray arrayWithObjects:@([ruleSystem minimumGradeForFacts:huntNearPlayerRawMinimumGradeForFacts]),
                                          nil];
    
    CGFloat huntPlayer = [self maxWithArray:huntPlayerRaw defaultValue:0.0];
    self.huntAgent = nil;
    
    if (huntPlayer > 0.0)
    {
        OGPlayerEntity *player = (OGPlayerEntity *) state.playerTarget[kOGEntitySnapshotPlayerBotTargetTargetKey];
        
        if (player.agent)
        {
            self.huntAgent = player.agent;
            self.mandate = kOGEnemyEntityMandateHunt;
        }
    }
    else
    {
        if (self.mandate != kOGEnemyEntityMandateFollowPath)
        {
            self.closestPointOnPath = [self closestPointOnPathWithGraph:self.graph];
            self.mandate = kOGEnemyEntityMandateReturnToPositionOnPath;
        }
    }
    
    OGEnemyEntityAgentControlledState *agentControlledState = (OGEnemyEntityAgentControlledState *) self.intelligenceComponent.stateMachine.currentState;
    if ([agentControlledState isMemberOfClass:OGEnemyEntityAgentControlledState.self]
        && agentControlledState.elapsedTime >= kOGEnemyEntityDelayBetweenAttacks
        && self.mandate == kOGEnemyEntityMandateHunt && self.huntAgent && [self distanceToAgentWithOtherAgent:self.huntAgent] <= 30.0)
    {
        if ([self.intelligenceComponent.stateMachine canEnterState:OGEnemyEntityPreAttackState.self])
        {
            [self.intelligenceComponent.stateMachine enterState:OGEnemyEntityPreAttackState.self];
        }
    }
}

#pragma mark - Other Methods
- (GKBehavior *)behaviorForCurrentMandate
{
    GKBehavior *result = nil;
    
    SKScene *scene = ((OGRenderComponent *) [self componentForClass:OGRenderComponent.self]).node.scene;
    
    if (!scene)
    {
        result = [[GKBehavior alloc] init];
    }
    else
    {
        switch (self.mandate)
        {
            case kOGEnemyEntityMandateFollowPath:
            {
                result = [OGEnemyBehavior behaviorWithAgent:self.agent
                                                      graph:self.graph
                                                 pathRadius:kOGEnemyEntityPatrolPathRadius
                                                      scene:(OGGameScene *)scene];
                break;
            }
            case kOGEnemyEntityMandateHunt:
            {
                result = [OGEnemyBehavior behaviorWithAgent:self.agent
                                               huntingAgent:self.huntAgent
                                                 pathRadius:kOGEnemyEntityPatrolPathRadius
                                                      scene:(OGGameScene *)scene];
                break;
            }
            case kOGEnemyEntityMandateReturnToPositionOnPath:
            {
                result = [OGEnemyBehavior behaviorWithAgent:self.agent
                                                   endPoint:self.closestPointOnPath
                                                 pathRadius:kOGEnemyEntityPatrolPathRadius
                                                      scene:(OGGameScene *)scene];
                break;
            }
            default:
                break;
        }
    
    }
    
    return result;
}

- (CGFloat)maxWithArray:(NSArray<NSNumber *> *)array defaultValue:(CGFloat)defaultValue
{
    CGFloat result = defaultValue;
    
    NSUInteger arrayCounter = array.count;
    
    if (arrayCounter != 0)
    {
        result = (result > array[0].floatValue) ? result : array[0].floatValue;
    }
    
    for (NSUInteger i = 0; i < arrayCounter - 1; i++)
    {
        result = (result > array[i+1].floatValue) ? result : array[i+1].floatValue;
    }
    
    return result;
}

#pragma mark count with graph
- (CGPoint)closestPointOnPathWithGraph:(GKGraph *)graph
{
    CGPoint enemyPosition = CGPointMake(self.agent.position.x, self.agent.position.y);
    
    NSUInteger nodesCounter = [graph.nodes count];
    
    CGPoint result = CGPointMake(((GKGraphNode2D *)graph.nodes[0]).position.x, ((GKGraphNode2D *)graph.nodes[0]).position.y);
    
    for (NSUInteger i = 0; i < nodesCounter - 1; i++)
    {
        CGFloat distance = [self distanceBetweenStartPoint:enemyPosition endPoint:result];
        CGPoint nextNodePosition = CGPointMake(((GKGraphNode2D *)graph.nodes[i+1]).position.x, ((GKGraphNode2D *)graph.nodes[i+1]).position.y);
        CGFloat nextDistance = [self distanceBetweenStartPoint:enemyPosition endPoint:nextNodePosition];
        
        result = (distance < nextDistance) ? result : nextNodePosition;
    }
    
    return result;
}

- (CGFloat)closestDistanceToAgentWithGraph:(GKGraph *)graph
{
    CGPoint enemyPosition = CGPointMake(self.agent.position.x, self.agent.position.y);
    
    NSUInteger nodesCounter = [graph.nodes count];
    
    CGPoint firstNodePosition = CGPointMake(((GKGraphNode2D *)graph.nodes[0]).position.x, ((GKGraphNode2D *)graph.nodes[0]).position.y);
    
    CGFloat result = [self distanceBetweenStartPoint:enemyPosition endPoint:firstNodePosition];
    
    for (NSUInteger i = 0; i < nodesCounter - 1; i++)
    {
        CGPoint nextNodePosition = CGPointMake(((GKGraphNode2D *)graph.nodes[i+1]).position.x, ((GKGraphNode2D *)graph.nodes[i+1]).position.y);
        CGFloat nextDistance = [self distanceBetweenStartPoint:enemyPosition endPoint:nextNodePosition];
        
        result = (result < nextDistance) ? result : nextDistance;
    }

    return result;
}

#pragma mark count distance
- (CGFloat)distanceToAgentWithOtherAgent:(GKAgent2D *)otherAgent
{
    CGPoint agentPosition = CGPointMake(self.agent.position.x, self.agent.position.y);
    CGPoint otherAgentPosition = CGPointMake(otherAgent.position.x, otherAgent.position.y);
    
    return [self distanceBetweenStartPoint:agentPosition endPoint:otherAgentPosition];
}

- (CGFloat)distanceBetweenStartPoint:(CGPoint)startPoint
                            endPoint:(CGPoint)endPoint
{
    CGFloat deltaX = startPoint.x - endPoint.x;
    CGFloat deltaY = startPoint.y - endPoint.y;
    
    return hypot(deltaX, deltaY);
}

#pragma mark updates
- (void)updateAgentPositionToMatchNodePosition
{
    OGRenderComponent *renderComponent = self.renderComponent;
    self.agent.position = (vector_float2){renderComponent.node.position.x + self.agentOffset.x, renderComponent.node.position.y + self.agentOffset.y};
}

- (void)updateNodePositionToMatchAgentPosition
{
    GKAgent2D *agent = self.agent;
    self.renderComponent.node.position = CGPointMake(agent.position.x - self.agentOffset.x, agent.position.y - self.agentOffset.y);
}

#pragma mark - Getters
- (CGPoint)agentOffset
{
    return CGPointMake(0.0, -25.0);
}
@end
