//
//  OGZombieMan.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/21/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGZombie.h"
#import "OGEnemyConfiguration.h"

#import "OGAnimationComponent.h"
#import "OGRenderComponent.h"
#import "OGPhysicsComponent.h"
#import "OGHealthComponent.h"
#import "OGOrientationComponent.h"
#import "OGIntelligenceComponent.h"
#import "OGTrailComponent.h"

#import "OGHealthComponentDelegate.h"

#import "OGEnemyEntityAgentControlledState.h"
#import "OGEnemyEntityPreAttackState.h"
#import "OGEnemyEntityAttackState.h"

NSTimeInterval const kOGEnemyEntityDelayBetweenAttacks = 1.0;

NSString *const kOGEnemyEntityAtlasNamesEnemyIdle = @"EnemyIdle";
NSString *const kOGEnemyEntityAtlasNamesEnemyWalk = @"EnemyWalk";
NSString *const kOGEnemyEntityAtlasNamesEnemyRun = @"EnemyRun";
NSString *const kOGEnemyEntityAtlasNamesEnemyAttack = @"EnemyAttack";
NSString *const kOGEnemyEntityAtlasNamesEnemyDead = @"EnemyDead";

static NSDictionary<NSString *, NSDictionary *> *sOGZombieAnimations;

@interface OGZombie () <OGHealthComponentDelegate>

@property (nonatomic, assign) CGFloat lastPositionX;

@end

@implementation OGZombie

- (instancetype)initWithConfiguration:(NSDictionary *)configuration
                                graph:(GKGraph *)graph
{
    self = [super initWithConfiguration:configuration graph:graph];
    
    if (self)
    {
        CGFloat physicsBodyRadius = [configuration[kOGEnemyEntityConfigurationPhysicsBodyRadiusKey] floatValue];
        
        _physicsComponent = [[OGPhysicsComponent alloc] initWithPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:physicsBodyRadius]
                                                               colliderType:[OGColliderType enemy]];
        [self addComponent:_physicsComponent];
        
        _healthComponent = [[OGHealthComponent alloc] init];
        _healthComponent.maxHealth = 10.0;
        _healthComponent.currentHealth = 10.0;
        
        [self addComponent:_healthComponent];
        
        _orientationComponent = [[OGOrientationComponent alloc] init];
        [self addComponent:_orientationComponent];
        
        
        CGPoint position = CGPointMake(((GKGraphNode2D *) [graph nodes][0]).position.x, ((GKGraphNode2D *) [graph nodes][0]).position.y);
        
        _renderComponent = [[OGRenderComponent alloc] init];
        _renderComponent.node.position = position;
        _renderComponent.node.physicsBody = _physicsComponent.physicsBody;
        _renderComponent.node.physicsBody.allowsRotation = NO;
        [self addComponent:_renderComponent];
        
        _lastPositionX = _renderComponent.node.position.x;
        
        _animationComponent = [[OGAnimationComponent alloc] initWithAnimations:[OGZombie sOGZombieAnimations]];
        [self addComponent:_animationComponent];
        
        [self.renderComponent.node addChild:_animationComponent.spriteNode];
        
        OGEnemyEntityAgentControlledState *agentControlledState = [[OGEnemyEntityAgentControlledState alloc] initWithEnemyEntity:self];
        OGEnemyEntityPreAttackState *preAttackState = [[OGEnemyEntityPreAttackState alloc] initWithEnemyEntity:self];
        OGEnemyEntityAttackState *attackState = [[OGEnemyEntityAttackState alloc] initWithEnemyEntity:self];

        _intelligenceComponent = [[OGIntelligenceComponent alloc] initWithStates:@[agentControlledState, preAttackState, attackState]];
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
    
    OGEnemyEntityAgentControlledState *agentControlledState = (OGEnemyEntityAgentControlledState *) self.intelligenceComponent.stateMachine.currentState;

    if ([agentControlledState isMemberOfClass:[OGEnemyEntityAgentControlledState class]]
        && agentControlledState.elapsedTime >= kOGEnemyEntityDelayBetweenAttacks
        && self.mandate == kOGEnemyEntityMandateHunt && self.huntAgent && [self distanceToAgentWithOtherAgent:self.huntAgent] <= 30.0)
    {
        if ([self.intelligenceComponent.stateMachine canEnterState:[OGEnemyEntityPreAttackState class]])
        {
            [self.intelligenceComponent.stateMachine enterState:[OGEnemyEntityPreAttackState class]];
        }
    }
}

#pragma mark - GKAgentDelegate Protocol Methods
- (void)agentDidUpdate:(GKAgent *)agent
{
    [super agentDidUpdate:agent];
    
    if (self.renderComponent.node.position.x != self.lastPositionX)
    {
        CGFloat differenceX = self.lastPositionX - _renderComponent.node.position.x;
        self.orientationComponent.direction = [OGOrientationComponent directionWithVectorX:differenceX];

        self.lastPositionX = _renderComponent.node.position.x;
    }
}

#pragma mark - OGResourceLoadable Protocol Methods
+ (BOOL)resourcesNeedLoading
{
    return sOGZombieAnimations == nil;
}

+ (void)loadResourcesWithCompletionHandler:(void (^)())completionHandler
{
    [OGEnemyEntity loadMiscellaneousAssets];
    
    NSArray *enemyAtlasNames = @[kOGEnemyEntityAtlasNamesEnemyIdle,
                                 kOGEnemyEntityAtlasNamesEnemyWalk,
                                 kOGEnemyEntityAtlasNamesEnemyRun,
                                 kOGEnemyEntityAtlasNamesEnemyAttack,
                                 kOGEnemyEntityAtlasNamesEnemyDead];
    
    [SKTextureAtlas preloadTextureAtlasesNamed:enemyAtlasNames withCompletionHandler:^(NSError *error, NSArray<SKTextureAtlas *> *foundAtlases)
     {
         NSMutableDictionary *animations = [NSMutableDictionary dictionary];
         
         animations[kOGAnimationStateDescription[kOGAnimationStateIdle]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[0]
                                                                                                     imageIdentifier:kOGEnemyEntityAtlasNamesEnemyIdle
                                                                                                      animationState:kOGAnimationStateIdle
                                                                                                      bodyActionName:nil
                                                                                               repeatTexturesForever:YES
                                                                                                       playBackwards:NO];
         
         animations[kOGAnimationStateDescription[kOGAnimationStateWalkForward]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[1]
                                                                                                            imageIdentifier:kOGEnemyEntityAtlasNamesEnemyWalk
                                                                                                             animationState:kOGAnimationStateWalkForward
                                                                                                             bodyActionName:nil
                                                                                                      repeatTexturesForever:YES
                                                                                                              playBackwards:NO];
         
         animations[kOGAnimationStateDescription[kOGAnimationStateRun]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[2]
                                                                                                    imageIdentifier:kOGEnemyEntityAtlasNamesEnemyRun
                                                                                                     animationState:kOGAnimationStateRun
                                                                                                     bodyActionName:nil
                                                                                              repeatTexturesForever:YES
                                                                                                      playBackwards:NO];
         
         animations[kOGAnimationStateDescription[kOGAnimationStateAttack]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[3]
                                                                                                       imageIdentifier:kOGEnemyEntityAtlasNamesEnemyAttack
                                                                                                        animationState:kOGAnimationStateAttack
                                                                                                        bodyActionName:nil
                                                                                                 repeatTexturesForever:NO
                                                                                                         playBackwards:NO];
         
         animations[kOGAnimationStateDescription[kOGAnimationStateDead]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[4]
                                                                                                     imageIdentifier:kOGEnemyEntityAtlasNamesEnemyDead
                                                                                                      animationState:kOGAnimationStateDead
                                                                                                      bodyActionName:nil
                                                                                               repeatTexturesForever:NO
                                                                                                       playBackwards:NO];
         
         sOGZombieAnimations = animations;
         
         completionHandler();
     }];
}

+ (void)purgeResources
{
    sOGZombieAnimations = nil;
}

#pragma mark - OGHealthComponentDelegate Protocol Methods
- (void)entityWillDie
{
    [self removeComponentForClass:self.agent.class];
}

#pragma mark - Getters
+ (NSDictionary *)sOGZombieAnimations
{
    return sOGZombieAnimations;
}

@end
