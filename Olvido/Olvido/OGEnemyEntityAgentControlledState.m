//
//  OGEnemyEntityAgentControlledState.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/15/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyEntityAgentControlledState.h"
#import "OGEnemyEntity.h"

#import "OGOrientationComponent.h"
#import "OGAnimationComponent.h"

#import "OGEnemyEntityPreAttackState.h"
#import "OGEnemyEntityDieState.h"

@interface OGEnemyEntityAgentControlledState ()

@property (nonatomic, weak) OGEnemyEntity *enemyEntity;

@property (nonatomic, assign) NSTimeInterval timeSinceBehaviorUpdate;

@property (nonatomic, weak) OGOrientationComponent *orientationComponent;
@property (nonatomic, weak) OGAnimationComponent *animationComponent;
@end

@implementation OGEnemyEntityAgentControlledState

- (instancetype)initWithEnemyEntity:(OGEnemyEntity *)enemyEntity
{
    self = [self init];
    
    if (self)
    {
        _enemyEntity = enemyEntity;
        _elapsedTime = 0.0;
        _timeSinceBehaviorUpdate = 0.0;
    }
    
    return self;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    self.timeSinceBehaviorUpdate = 0.0;
    self.elapsedTime = 0.0;
    
    self.enemyEntity.agent.behavior = [self.enemyEntity behaviorForCurrentMandate];
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    self.timeSinceBehaviorUpdate += seconds;
    self.elapsedTime += seconds;
    
    if (self.timeSinceBehaviorUpdate >= kOGEnemyEntityBehaviorUpdateWaitDuration)
    {
        if (self.enemyEntity.mandate == kOGEnemyEntityMandateReturnToPositionOnPath)
        {
            CGPoint enemyPosition = CGPointMake(self.enemyEntity.agent.position.x, self.enemyEntity.agent.position.y);
            
            if ([self.enemyEntity distanceBetweenStartPoint:enemyPosition endPoint:self.enemyEntity.closestPointOnPath]
                <= kOGEnemyEntityThresholdProximityToPatrolPathStartPoint)
            {
                self.enemyEntity.mandate = kOGEnemyEntityMandateFollowPath;
            }
        }
        
        self.enemyEntity.agent.behavior = [self.enemyEntity behaviorForCurrentMandate];
        
        self.timeSinceBehaviorUpdate = 0.0;
        
        if (self.enemyEntity.mandate == kOGEnemyEntityMandateHunt)
        {
            self.animationComponent.requestedAnimationState = kOGAnimationStateRun;
        }
        else
        {
            self.animationComponent.requestedAnimationState = kOGAnimationStateWalkForward;
        }
    }
}

- (void)willExitWithNextState:(GKState *)nextState
{
    [super willExitWithNextState:nextState];
    
    self.enemyEntity.agent.behavior = [[GKBehavior alloc] init];
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [OGEnemyEntityPreAttackState class] || stateClass == [OGEnemyEntityDieState class];
}

#pragma mark - Getters
- (OGOrientationComponent *)orientationComponent
{
    if (!_orientationComponent)
    {
        _orientationComponent = (OGOrientationComponent *) [self.enemyEntity componentForClass:[OGOrientationComponent class]];
    }
    
    return _orientationComponent;
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
