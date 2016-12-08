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

@interface OGEnemyEntityPreAttackState () <OGAnimationComponentDelegate>

@property (nonatomic, weak) OGEnemyEntity *enemyEntity;

@property (nonatomic, weak) OGAnimationComponent *animationComponent;

@end

@implementation OGEnemyEntityPreAttackState

#pragma mark - Initializing

- (instancetype)initWithEnemyEntity:(OGEnemyEntity *)enemyEntity
{
    self = [self init];
    
    if (self)
    {
        _enemyEntity = enemyEntity;
    }
    
    return self;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    self.animationComponent.delegate = self;
    self.animationComponent.requestedAnimationState = OGConstantsAttack;
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [OGEnemyEntityAttackState class] || stateClass == [OGEnemyEntityDieState class];
}

- (void)animationDidFinish
{
    self.animationComponent.delegate = nil;
    
    if ([self.stateMachine canEnterState:[OGEnemyEntityAttackState class]])
    {
        [self.stateMachine enterState:[OGEnemyEntityAttackState class]];
    }
}

#pragma mark - Getters

- (OGAnimationComponent *)animationComponent
{
    if (!_animationComponent)
    {
        _animationComponent = (OGAnimationComponent *) [self.enemyEntity componentForClass:[OGAnimationComponent class]];
    }
    
    return _animationComponent;
}

@end
