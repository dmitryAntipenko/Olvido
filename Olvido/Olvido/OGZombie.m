//
//  OGZombieMan.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/21/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGZombie.h"
#import "OGPlayerEntity.h"
#import "OGEnemyConfiguration.h"

#import "OGAnimationComponent.h"
#import "OGRenderComponent.h"
#import "OGHealthComponent.h"
#import "OGOrientationComponent.h"
#import "OGIntelligenceComponent.h"
#import "OGTrailComponent.h"
#import "OGPhysicsComponent.h"

#import "OGEnemyEntityAgentControlledState.h"
#import "OGEnemyEntityPreAttackState.h"
#import "OGEnemyEntityAttackState.h"
#import "OGEnemyEntityDieState.h"

static BOOL sResourcesNeedLoading = YES;

@interface OGZombie ()

@property (nonatomic, strong) OGIntelligenceComponent *intelligenceComponent;
@property (nonatomic, strong) OGTrailComponent *trailComponent;

@property (nonatomic, assign) CGFloat lastPositionX;
@property (nonatomic, weak) SKPhysicsBody *huntContactBody;

@end

@implementation OGZombie

- (instancetype)initWithConfiguration:(OGEnemyConfiguration *)configuration
                                graph:(GKGraph *)graph
{
    self = [super initWithConfiguration:configuration graph:graph];
    
    if (self)
    {
        _lastPositionX = self.renderComponent.node.position.x;
        
        OGEnemyEntityAgentControlledState *agentControlledState = [[OGEnemyEntityAgentControlledState alloc] initWithEnemyEntity:self];
        OGEnemyEntityPreAttackState *preAttackState = [[OGEnemyEntityPreAttackState alloc] initWithEnemyEntity:self];
        OGEnemyEntityAttackState *attackState = [[OGEnemyEntityAttackState alloc] initWithEnemyEntity:self];
        OGEnemyEntityDieState *dieState = [[OGEnemyEntityDieState alloc] initWithEnemyEntity:self];

        _intelligenceComponent = [[OGIntelligenceComponent alloc] initWithStates:@[agentControlledState, preAttackState, attackState, dieState]];
        [self addComponent:_intelligenceComponent];
        
        //TEMPORARY
        _trailComponent = [OGTrailComponent trailComponent];
        _trailComponent.texture = [SKTexture textureWithImageNamed:@"slime"];
        _trailComponent.textureSize = CGSizeMake(64.0, 64.0);
        [self addComponent:_trailComponent];
        //TEMPORARY
    }
    
    return self;
}

#pragma mark - OGRulesComponentDelegate Protocol Methods

- (void)rulesComponentWithRulesComponent:(OGRulesComponent *)rulesComponent ruleSystem:(GKRuleSystem *)ruleSystem
{
    [super rulesComponentWithRulesComponent:rulesComponent ruleSystem:ruleSystem];
    
    GKState *currentState = self.intelligenceComponent.stateMachine.currentState;
   
    if ([currentState isMemberOfClass:[OGEnemyEntityAgentControlledState class]]
        && self.huntAgent && self.huntContactBody)
    {
        self.orientationComponent.currentOrientation = [OGOrientationComponent orientationWithVectorX:(self.huntAgent.position.x - self.agent.position.x)];
        [self.intelligenceComponent.stateMachine enterState:[OGEnemyEntityPreAttackState class]];
    }
}

#pragma mark - OGContactNotifiableType Protocol Methods

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    [super contactWithEntityDidBegin:entity];
    
    if ([entity isMemberOfClass:[OGPlayerEntity class]] && !self.huntContactBody
        && ![self.intelligenceComponent.stateMachine.currentState isMemberOfClass:[OGEnemyEntityPreAttackState class]]
        && ![self.intelligenceComponent.stateMachine.currentState isMemberOfClass:[OGEnemyEntityAttackState class]])
    {
        OGPhysicsComponent *physicsComponent = (OGPhysicsComponent *) [entity componentForClass:[OGPhysicsComponent class]];
        self.huntContactBody = physicsComponent.physicsBody;
        self.agent.behavior = nil;
        [self.intelligenceComponent.stateMachine enterState:[OGEnemyEntityPreAttackState class]];
    }
}

- (void)contactWithEntityDidEnd:(GKEntity *)entity
{
    [super contactWithEntityDidEnd:entity];
    
    if ([entity isMemberOfClass:[OGPlayerEntity class]])
    {
        self.huntContactBody = nil;
        
        if ([self.intelligenceComponent.stateMachine canEnterState:[OGEnemyEntityAgentControlledState class]])
        {
            [self.intelligenceComponent.stateMachine enterState:[OGEnemyEntityAgentControlledState class]];
        }
    }
}

#pragma mark - GKAgentDelegate Protocol Methods

- (void)agentDidUpdate:(GKAgent *)agent
{
    [super agentDidUpdate:agent];
    
    if (self.renderComponent.node.position.x != self.lastPositionX)
    {
        CGFloat differenceX = self.renderComponent.node.position.x - self.lastPositionX;
        
        if (differenceX != 0 && !self.huntContactBody)
        {
            self.orientationComponent.currentOrientation = [OGOrientationComponent orientationWithVectorX:differenceX];
        }

        self.lastPositionX = self.renderComponent.node.position.x;
    }
}

#pragma mark - OGResourceLoadable Protocol Methods

+ (BOOL)resourcesNeedLoading
{
    return sResourcesNeedLoading;
}

+ (void)loadResourcesWithCompletionHandler:(void (^)())completionHandler
{
    [OGEnemyEntity loadMiscellaneousAssets];
    sResourcesNeedLoading = NO;

    completionHandler();
}

+ (void)purgeResources
{
    sResourcesNeedLoading = YES;
}

#pragma mark - OGHealthComponentDelegate Protocol Methods

- (void)entityWillDie
{
    [super entityWillDie];
    
    if ([self.intelligenceComponent.stateMachine canEnterState:[OGEnemyEntityDieState class]])
    {
        [self.intelligenceComponent.stateMachine enterState:[OGEnemyEntityDieState class]];
    }
}

@end
