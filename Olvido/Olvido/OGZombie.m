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

NSTimeInterval const kOGEnemyEntityDelayBetweenAttacks = 1.0;

NSString *const kOGEnemyEntityAtlasNamesEnemyIdle = @"EnemyIdle";
NSString *const kOGEnemyEntityAtlasNamesEnemyWalk = @"EnemyWalk";
NSString *const kOGEnemyEntityAtlasNamesEnemyRun = @"EnemyRun";
NSString *const kOGEnemyEntityAtlasNamesEnemyAttack = @"EnemyAttack";
NSString *const kOGEnemyEntityAtlasNamesEnemyDead = @"EnemyDead";

static NSDictionary<NSString *, NSDictionary *> *sOGZombieAnimations;

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
        self.orientationComponent.direction = [OGOrientationComponent directionWithVectorX:(self.agent.position.x - self.huntAgent.position.x)];
        [self.intelligenceComponent.stateMachine enterState:[OGEnemyEntityPreAttackState class]];
    }
}

#pragma mark - OGContactNotifiableType Protocol Methods

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    [super contactWithEntityDidBegin:entity];
    
    if ([entity isMemberOfClass:[OGPlayerEntity class]] && !self.huntContactBody)
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
        CGFloat differenceX = self.lastPositionX - self.renderComponent.node.position.x;
        
        if (differenceX != 0 && !self.huntContactBody)
        {
            self.orientationComponent.direction = [OGOrientationComponent directionWithVectorX:differenceX];
        }

        self.lastPositionX = self.renderComponent.node.position.x;
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
         
//         animations[kOGAnimationStateDescription[kOGAnimationStateIdle]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[0]
//                                                                                                     imageIdentifier:kOGEnemyEntityAtlasNamesEnemyIdle
//                                                                                                      animationState:kOGAnimationStateIdle
//                                                                                                      bodyActionName:nil
//                                                                                               repeatTexturesForever:YES
//                                                                                                       playBackwards:NO
//                                                                                                        timePerFrame:0.1];
//         
//         animations[kOGAnimationStateDescription[kOGAnimationStateWalkForward]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[1]
//                                                                                                            imageIdentifier:kOGEnemyEntityAtlasNamesEnemyWalk
//                                                                                                             animationState:kOGAnimationStateWalkForward
//                                                                                                             bodyActionName:nil
//                                                                                                      repeatTexturesForever:YES
//                                                                                                              playBackwards:NO
//                                                                                                               timePerFrame:0.1];
//         
//         animations[kOGAnimationStateDescription[kOGAnimationStateRun]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[2]
//                                                                                                    imageIdentifier:kOGEnemyEntityAtlasNamesEnemyRun
//                                                                                                     animationState:kOGAnimationStateRun
//                                                                                                     bodyActionName:nil
//                                                                                              repeatTexturesForever:YES
//                                                                                                      playBackwards:NO
//                                                                                                       timePerFrame:0.1];
//         
//         animations[kOGAnimationStateDescription[kOGAnimationStateAttack]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[3]
//                                                                                                       imageIdentifier:kOGEnemyEntityAtlasNamesEnemyAttack
//                                                                                                        animationState:kOGAnimationStateAttack
//                                                                                                        bodyActionName:nil
//                                                                                                 repeatTexturesForever:YES
//                                                                                                         playBackwards:NO
//                                                                                                          timePerFrame:0.1];
//         
//         animations[kOGAnimationStateDescription[kOGAnimationStateDead]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[4]
//                                                                                                     imageIdentifier:kOGEnemyEntityAtlasNamesEnemyDead
//                                                                                                      animationState:kOGAnimationStateDead
//                                                                                                      bodyActionName:nil
//                                                                                               repeatTexturesForever:NO
//                                                                                                       playBackwards:NO
//                                                                                                        timePerFrame:0.1];
         
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
    [super entityWillDie];
    
    if ([self.intelligenceComponent.stateMachine canEnterState:[OGEnemyEntityDieState class]])
    {
        [self.intelligenceComponent.stateMachine enterState:[OGEnemyEntityDieState class]];
    }
}

#pragma mark - Getters

+ (NSDictionary *)sOGZombieAnimations
{
    return sOGZombieAnimations;
}

@end
