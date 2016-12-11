//
//  OGEnemyEntityPreAttackState.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/18/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyEntityPreAttackState.h"
#import "OGAnimationComponent.h"
#import "OGAnimation.h"
#import "OGEnemyEntity.h"

#import "OGEnemyEntityAttackState.h"
#import "OGEnemyEntityAgentControlledState.h"
#import "OGEnemyEntityDieState.h"

#import "OGConstants.h"

@interface OGEnemyEntityPreAttackState () <OGAnimationComponentDelegate>

@property (nonatomic, weak) OGEnemyEntity *enemyEntity;

@property (nonatomic, weak) OGAnimationComponent *animationComponent;

@property (nonatomic, assign) NSTimeInterval timeSinceAnimationStart;
@property (nonatomic, assign, getter=animationIsStarted) BOOL animationStarted;

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
    
    self.timeSinceAnimationStart = 0.0;
    self.animationStarted = NO;
    self.animationComponent.delegate = self;
    self.animationComponent.requestedAnimationState = OGConstantsAttack;
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [OGEnemyEntityAttackState class] || stateClass == [OGEnemyEntityDieState class];
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    if (self.animationIsStarted)
    {
        self.timeSinceAnimationStart += seconds;
        
        OGAnimation *currentAnimation = self.animationComponent.currentAnimation;
        
        if (currentAnimation.textures.count / 2.0 * currentAnimation.timePerFrame < self.timeSinceAnimationStart)
        {
            if ([self.stateMachine canEnterState:[OGEnemyEntityAttackState class]])
            {
                [self.stateMachine enterState:[OGEnemyEntityAttackState class]];
                self.animationStarted = NO;
            }
        }
    }
}


- (void)animationDidStart
{
    self.animationStarted = YES;
}

- (void) animationDidFinish
{
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
