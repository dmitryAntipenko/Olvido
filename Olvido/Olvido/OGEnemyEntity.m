//
//  OGEnemyEntity.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyEntity.h"
#import "OGEnemyConfiguration.h"

#import "OGRenderComponent.h"
#import "OGIntelligenceComponent.h"
#import "OGRulesComponent.h"
#import "OGEnemyBehavior.h"
#import "OGOrientationComponent.h"
#import "OGAnimationComponent.h"
#import "OGPhysicsComponent.h"
#import "OGHealthComponent.h"
#import "OGHealthBarComponent.h"
#import "OGShadowComponent.h"

#import "OGAnimation.h"

#import "OGEnemyEntityAgentControlledState.h"
#import "OGEnemyEntityPreAttackState.h"
#import "OGEnemyEntityAttackState.h"

#import "OGEntitySnapshot.h"
#import "OGEntityDistance.h"

#import "OGPlayerNearRule.h"
#import "OGPlayerMediumRule.h"
#import "OGPlayerFarRule.h"

#import "OGPlayerEntity.h"
#import "OGZPositionEnum.m"

#import "OGColliderType.h"

#import "OGZombie.h"

#import "OGTextureConfiguration.h"

static OGTextureConfiguration *sOGEnemyEntityDefaultTextureConfiguration = nil;

NSTimeInterval const OGEnemyEntityMaxPredictionTimeForObstacleAvoidance = 1.0;
NSTimeInterval const OGEnemyEntityBehaviorUpdateWaitDuration = 0.25;

CGFloat const OGEnemyEntityPathfindingGraphBufferRadius = 30.0;
CGFloat const OGEnemyEntityPatrolPathRadius = 10.0;
CGFloat const OGEnemyEntityWalkMaxSpeed = 50;
CGFloat const OGEnemyEntityHuntMaxSpeed = 500;
CGFloat const OGEnemyEntityMaximumAcceleration = 300.0;
CGFloat const OGEnemyEntityAgentMass = 0.25;
CGFloat const OGEnemyEntityThresholdProximityToPatrolPathStartPoint = 50.0;

NSUInteger const OGEnemyEntityDealDamage = 1.0;

NSString *const OGEnemyEntityShadowTextureName = @"PlayerShadow";
CGFloat const OGEnemyEntityShadowYOffset = -70.0;

@interface OGEnemyEntity ()

@property (nonatomic, strong) GKBehavior *behaviorForCurrentMandate;
@property (nonatomic, weak) GKAgent2D *huntAgent;

@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;
@property (nonatomic, strong) OGHealthComponent *healthComponent;
@property (nonatomic, strong) OGAnimationComponent *animationComponent;
@property (nonatomic, strong) OGOrientationComponent *orientationComponent;
@property (nonatomic, strong) OGHealthBarComponent *healthBarComponent;
@property (nonatomic, strong) OGShadowComponent *shadowComponent;

@property (nonatomic, strong) NSString *unitName;

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
        
        _renderComponent = [[OGRenderComponent alloc] init];
        [self addComponent:_renderComponent];
        
        _physicsComponent = [[OGPhysicsComponent alloc] initWithPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:configuration.physicsBodyRadius]
                                                               colliderType:[OGColliderType enemy]];
        
        [self addComponent:_physicsComponent];
        
        SKTexture *shadowTexture = [SKTexture textureWithImageNamed:OGEnemyEntityShadowTextureName];
        _shadowComponent = [[OGShadowComponent alloc] initWithTexture:shadowTexture offset:-configuration.physicsBodyRadius];
        [self addComponent:_shadowComponent];
        
        [_renderComponent.node addChild:_shadowComponent.node];
        
        _healthComponent = [[OGHealthComponent alloc] init];
        _healthComponent.maxHealth = configuration.maxHealth;
        _healthComponent.currentHealth = configuration.currentHealth;
        _healthComponent.delegate = self;
        [self addComponent:_healthComponent];
        
        _orientationComponent = [[OGOrientationComponent alloc] init];
        [self addComponent:_orientationComponent];
        
        GKGraphNode2D *initialNode = (GKGraphNode2D *) [graph nodes][0];
        CGPoint position = CGPointMake(initialNode.position.x, initialNode.position.y);
        
        _renderComponent.node.position = position;
        _renderComponent.node.physicsBody = _physicsComponent.physicsBody;
        _renderComponent.node.physicsBody.allowsRotation = NO;
        
        NSMutableDictionary *animations = [NSMutableDictionary dictionary];
        
        _unitName = configuration.unitName;
        
        for (OGTextureConfiguration *textureConfiguration in configuration.textures)
        {
            OGAnimation *animation = [OGAnimation animationWithTextureConfiguration:textureConfiguration
                                                               defaultConfiguration:sOGEnemyEntityDefaultTextureConfiguration
                                                                           unitName:_unitName];
            
            animations[animation.stateName] = animation;
        }
        
        _animationComponent = [[OGAnimationComponent alloc] initWithAnimations:animations];
        _animationComponent.spriteNode.anchorPoint = CGPointMake(0.5, 0.0);
        _animationComponent.spriteNode.position = CGPointMake(0.0, -configuration.physicsBodyRadius);
        [self addComponent:_animationComponent];
        
        
        [self.renderComponent.node addChild:_animationComponent.spriteNode];
        
        _mandate = OGEnemyEntityMandateFollowPath;
 
        _agent = [[GKAgent2D alloc] init];
        _agent.delegate = self;
        _agent.maxSpeed = OGEnemyEntityWalkMaxSpeed;
        _agent.maxAcceleration = OGEnemyEntityMaximumAcceleration;
        _agent.mass = OGEnemyEntityAgentMass;
        _agent.radius = configuration.physicsBodyRadius;
        _agent.behavior = [[GKBehavior alloc] init];
        [self addComponent:_agent];

        OGPlayerNearRule *playerNearRule = [[OGPlayerNearRule alloc] init];
        OGPlayerMediumRule *playerMediumRule = [[OGPlayerMediumRule alloc] init];
        OGPlayerFarRule *playerFarRule = [[OGPlayerFarRule alloc] init];
        
        _rulesComponent = [[OGRulesComponent alloc] initWithRules:@[playerNearRule, playerMediumRule, playerFarRule]];
        [self addComponent:_rulesComponent];
        
        _rulesComponent.delegate = self;
        
        _healthBarComponent = [OGHealthBarComponent healthBarComponent];
        [self addComponent:_healthBarComponent];
    }
    
    return self;
}

#pragma mark - GKAgentDelegate Protocol Methods

- (void)agentWillUpdate:(GKAgent *)agent
{
    [self updateAgentPositionToMatchNodePosition];
}

- (void)agentDidUpdate:(GKAgent *)agent
{
    OGIntelligenceComponent *intelligenceComponent = (OGIntelligenceComponent *) [self componentForClass:[OGIntelligenceComponent class]];
    OGOrientationComponent *orientationComponent = (OGOrientationComponent *) [self componentForClass:[OGOrientationComponent class]];
    
    if (intelligenceComponent && orientationComponent)
    {
        if ([intelligenceComponent.stateMachine.currentState isMemberOfClass:[OGEnemyEntityAgentControlledState class]])
        {
            if (self.mandate == OGEnemyEntityMandateHunt)
            {
                self.agent.maxSpeed = OGEnemyEntityHuntMaxSpeed;
            }
            else
            {
                self.agent.maxSpeed = OGEnemyEntityWalkMaxSpeed;
            }
            
            [self updateNodePositionToMatchAgentPosition];
        }
        else
        {
            [self updateAgentPositionToMatchNodePosition];
        }
    }
}

#pragma mark - OGContactNotifiableType Protocol Methods

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    
}

- (void)contactWithEntityDidEnd:(GKEntity *)entity
{
    
}

#pragma mark - OGRulesComponentDelegate Protocol Methods

- (void)rulesComponentWithRulesComponent:(OGRulesComponent *)rulesComponent ruleSystem:(GKRuleSystem *)ruleSystem
{
    NSArray<NSNumber *> *huntNearPlayerRawGradeForFacts = @[@(OGFuzzyEnemyRuleFactPlayerMedium)];
    
    NSArray<NSNumber *> *huntPlayerRaw = @[@([ruleSystem minimumGradeForFacts:huntNearPlayerRawGradeForFacts])];
    
    CGFloat huntPlayer = [self maxWithArray:huntPlayerRaw defaultValue:0.0];
    self.huntAgent = nil;

    if (huntPlayer > 0.0)
    {
        OGEntitySnapshot *state = ruleSystem.state[OGRulesComponentRuleSystemStateSnapshot];
        OGPlayerEntity *player = (OGPlayerEntity *) state.playerTarget[OGEntitySnapshotPlayerBotTargetTargetKey];
        GKAgent2D *agent = (GKAgent2D *) [player componentForClass:[GKAgent2D class]];
        
        if (agent)
        {
            self.huntAgent = agent;
            self.mandate = OGEnemyEntityMandateHunt;
        }
    }
    else
    {
        if (self.mandate != OGEnemyEntityMandateFollowPath)
        {
            self.closestPointOnPath = [self closestPointOnPathWithGraph:self.graph];
            self.mandate = OGEnemyEntityMandateReturnToPositionOnPath;
        }
    }
}

#pragma mark - OGHealthComponentDelegate Protocol Methods

- (void)healthDidChange
{
    [self.healthBarComponent redrawBarNode];
}

- (void)entityWillDie
{
    
}

- (void)dealDamageToEntity:(NSInteger)damage
{
    if (self.healthComponent)
    {
        [self.healthComponent dealDamage:damage];
    }
}

#pragma mark - Other Method

- (void)entityDidDie
{
    SKTexture *texture = self.animationComponent.spriteNode.texture;
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithTexture:texture];
    node.position = self.renderComponent.node.position;

    [self.renderComponent.node.scene addChild:node];
    
    [self.delegate removeEntity:self];
}

- (GKBehavior *)behaviorForCurrentMandate
{
    GKBehavior *result = nil;
    
    SKScene *scene = ((OGRenderComponent *) [self componentForClass:[OGRenderComponent class]]).node.scene;
    
    if (scene)
    {
        switch (self.mandate)
        {
            case OGEnemyEntityMandateFollowPath:
            {
                result = [OGEnemyBehavior behaviorWithAgent:self.agent
                                                      graph:self.graph
                                                 pathRadius:OGEnemyEntityPatrolPathRadius
                                                      scene:(OGGameScene *)scene];
                break;
            }
            case OGEnemyEntityMandateHunt:
            {
                result = [OGEnemyBehavior behaviorWithAgent:self.agent
                                               huntingAgent:self.huntAgent
                                                 pathRadius:OGEnemyEntityPatrolPathRadius
                                                      scene:(OGGameScene *)scene];
                break;
            }
            case OGEnemyEntityMandateReturnToPositionOnPath:
            {
                result = [OGEnemyBehavior behaviorWithAgent:self.agent
                                                   endPoint:self.closestPointOnPath
                                                 pathRadius:OGEnemyEntityPatrolPathRadius
                                                      scene:(OGGameScene *)scene];
                break;
            }
        }        
    }
    else
    {
        result = [[GKBehavior alloc] init];
    }
    
    return result;
}

- (CGFloat)maxWithArray:(NSArray<NSNumber *> *)array defaultValue:(CGFloat)defaultValue
{
    CGFloat result = defaultValue;

    for (NSUInteger i = 0; i < array.count; i++)
    {
        result = MAX(result, array[i].floatValue);
    }
    
    return result;
}

#pragma mark count with graph

- (CGPoint)closestPointOnPathWithGraph:(GKGraph *)graph
{
    CGPoint enemyPosition = CGPointMake(self.agent.position.x, self.agent.position.y);
    
    NSUInteger nodesCounter = graph.nodes.count;
    
    GKGraphNode2D *graphNode = ((GKGraphNode2D *) graph.nodes[0]);
    CGPoint result = CGPointMake(graphNode.position.x, graphNode.position.y);
    
    for (NSUInteger i = 1; i < nodesCounter; i++)
    {
        CGFloat distance = [self distanceBetweenStartPoint:enemyPosition endPoint:result];
        
        graphNode = ((GKGraphNode2D *)graph.nodes[i]);
        CGPoint nextNodePosition = CGPointMake(graphNode.position.x, graphNode.position.y);
        CGFloat nextDistance = [self distanceBetweenStartPoint:enemyPosition endPoint:nextNodePosition];
        
        result = (distance < nextDistance) ? result : nextNodePosition;
    }
    
    return result;
}

- (CGFloat)closestDistanceToAgentWithGraph:(GKGraph *)graph
{
    CGPoint enemyPosition = CGPointMake(self.agent.position.x, self.agent.position.y);
    
    NSUInteger nodesCounter = [graph.nodes count];
    
    GKGraphNode2D *graphNode = ((GKGraphNode2D *) graph.nodes[0]);
    CGPoint firstNodePosition = CGPointMake(graphNode.position.x, graphNode.position.y);
    
    CGFloat result = [self distanceBetweenStartPoint:enemyPosition endPoint:firstNodePosition];
    
    for (NSUInteger i = 1; i < nodesCounter; i++)
    {
        graphNode = ((GKGraphNode2D *)graph.nodes[i]);
        CGPoint nextNodePosition = CGPointMake(graphNode.position.x, graphNode.position.y);
        CGFloat nextDistance = [self distanceBetweenStartPoint:enemyPosition endPoint:nextNodePosition];
        
        result = MIN(result, nextDistance);
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
    OGRenderComponent *renderComponent = (OGRenderComponent *) [self componentForClass:[OGRenderComponent class]];
    
    if (renderComponent)
    {
        self.agent.position = (vector_float2){renderComponent.node.position.x, renderComponent.node.position.y};
    }
}

- (void)updateNodePositionToMatchAgentPosition
{
    GKAgent2D *agent = self.agent;
    
    OGRenderComponent *renderComponent = (OGRenderComponent *) [self componentForClass:[OGRenderComponent class]];
    
    if (renderComponent)
    {
        renderComponent.node.position = CGPointMake(agent.position.x, agent.position.y);
    }
}

#pragma mark - Miscellaneous Assets

+ (void)loadMiscellaneousAssets
{
    NSArray *collisionColliders = @[[OGColliderType obstacle], [OGColliderType door], [OGColliderType player], [OGColliderType enemy]];
    [[OGColliderType definedCollisions] setObject:collisionColliders forKey:[OGColliderType enemy]];
    
    NSArray *contactColliders = @[[OGColliderType player]];
    [[OGColliderType requestedContactNotifications] setObject:contactColliders forKey:[OGColliderType enemy]];
}

@end
