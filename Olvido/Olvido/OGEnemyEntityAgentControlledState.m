//
//  OGEnemyEntityAgentControlledState.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/15/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyEntityAgentControlledState.h"
#import "OGEnemyEntity.h"

#import "OGAnimationComponent.h"

#import "OGEnemyEntityPreAttackState.h"
#import "OGEnemyEntityDieState.h"

#import "OGConstants.h"

CGFloat const OGEnemyEntityAgentControlledStateWalkMaxSpeed = 50;
CGFloat const OGEnemyEntityAgentControlledStateHuntMaxSpeed = 500;

@interface OGEnemyEntityAgentControlledState ()

@property (nonatomic, weak) OGEnemyEntity *enemyEntity;

@property (nonatomic, assign) NSTimeInterval timeSinceBehaviorUpdate;
@property (nonatomic, assign) NSTimeInterval elapsedTime;

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

    self.animationComponent.requestedAnimationState = OGConstantsWalk;
    self.enemyEntity.agent.behavior = [self.enemyEntity behaviorForCurrentMandate];
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    self.timeSinceBehaviorUpdate += seconds;
    self.elapsedTime += seconds;
    
    if (self.timeSinceBehaviorUpdate >= OGEnemyEntityBehaviorUpdateWaitDuration)
    {
        if (self.enemyEntity.mandate == OGEnemyEntityMandateReturnToPositionOnPath)
        {
            CGPoint enemyPosition = CGPointMake(self.enemyEntity.agent.position.x, self.enemyEntity.agent.position.y);
            
            if ([self.enemyEntity distanceBetweenStartPoint:enemyPosition endPoint:self.enemyEntity.closestPointOnPath]
                <= OGEnemyEntityThresholdProximityToPatrolPathStartPoint)
            {
                self.enemyEntity.mandate = OGEnemyEntityMandateFollowPath;
            }
        }
        
        self.enemyEntity.agent.behavior = [self.enemyEntity behaviorForCurrentMandate];
        
        self.timeSinceBehaviorUpdate = 0.0;
        
        if (self.enemyEntity.mandate == OGEnemyEntityMandateHunt)
        {
            self.enemyEntity.agent.maxSpeed = OGEnemyEntityAgentControlledStateHuntMaxSpeed;
            self.animationComponent.requestedAnimationState = OGConstantsRun;
        }
        else if (self.enemyEntity.mandate == OGEnemyEntityMandateCheckPoint)
        {
            self.enemyEntity.agent.maxSpeed = OGEnemyEntityAgentControlledStateHuntMaxSpeed;
            self.animationComponent.requestedAnimationState = OGConstantsRun;
        }
        else
        {
            self.enemyEntity.agent.maxSpeed = OGEnemyEntityAgentControlledStateWalkMaxSpeed;
            self.animationComponent.requestedAnimationState = OGConstantsWalk;
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

- (OGAnimationComponent *)animationComponent
{
    if (!_animationComponent)
    {
        _animationComponent = (OGAnimationComponent *) [self.enemyEntity componentForClass:[OGAnimationComponent class]];
    }
    
    return _animationComponent;
}


@end
