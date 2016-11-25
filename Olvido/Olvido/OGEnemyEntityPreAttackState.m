//
//  OGEnemyEntityPreAttackState.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/18/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyEntityPreAttackState.h"
#import "OGAnimationComponent.h"
#import "OGEnemyEntity.h"

#import "OGEnemyEntityAttackState.h"
#import "OGEnemyEntityAgentControlledState.h"
#import "OGEnemyEntityDieState.h"

#import "OGConstants.h"

NSTimeInterval const kOGEnemyEntityPreAttackStatePreAttackStateDuration = 0.3;

@interface OGEnemyEntityPreAttackState ()

@property (nonatomic, weak) OGEnemyEntity *enemyEntity;

@property (nonatomic, assign) NSTimeInterval elapsedTime;
@property (nonatomic, assign) NSTimeInterval elapsedTimeForAnimation;

@property (nonatomic, weak) OGAnimationComponent *animationComponent;

@end

@implementation OGEnemyEntityPreAttackState

- (instancetype)initWithEnemyEntity:(OGEnemyEntity *)enemyEntity
{
    self = [self init];
    
    if (self)
    {
        _enemyEntity = enemyEntity;
        _elapsedTime = 0.0;
        _elapsedTimeForAnimation = 0.0;
    }
    
    return self;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    self.elapsedTime = 0.0;
    self.elapsedTimeForAnimation = 0.0;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    self.elapsedTime += seconds;
    
    if (self.elapsedTime >= kOGEnemyEntityPreAttackStatePreAttackStateDuration)
    {
        self.animationComponent.requestedAnimationState = kOGConstantsAttack;

        if ([self.stateMachine canEnterState:[OGEnemyEntityAttackState class]])
        {
            [self.stateMachine enterState:[OGEnemyEntityAttackState class]];
        }
    }
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [OGEnemyEntityAttackState class] || stateClass == [OGEnemyEntityAgentControlledState class]
    || stateClass == [OGEnemyEntityDieState class];
}

- (OGAnimationComponent *)animationComponent
{
    if (!_animationComponent)
    {
        _animationComponent = (OGAnimationComponent *) [self.enemyEntity componentForClass:[OGAnimationComponent class]];
    }
    
    return _animationComponent;
}

@end
