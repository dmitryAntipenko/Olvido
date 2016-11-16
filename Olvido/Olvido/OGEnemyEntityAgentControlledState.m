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

@interface OGEnemyEntityAgentControlledState ()

@property (nonatomic, weak) OGEnemyEntity *enemyEntity;

@property (nonatomic, assign) NSTimeInterval elapsedTime;
@property (nonatomic, assign) NSTimeInterval timeSinceBehaviorUpdate;

@property (nonatomic, strong) OGOrientationComponent *orientationComponent;

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
        self.enemyEntity.agent.behavior = [self.enemyEntity behaviorForCurrentMandate];
        
        self.timeSinceBehaviorUpdate = 0.0;
    }
}

- (void)willExitWithNextState:(GKState *)nextState
{
    [super willExitWithNextState:nextState];
    
    self.enemyEntity.agent.behavior = [[GKBehavior alloc] init];
}

- (OGOrientationComponent *)orientationComponent
{
    if (!_orientationComponent)
    {
        _orientationComponent = (OGOrientationComponent *) [self.enemyEntity componentForClass:OGOrientationComponent.self];
    }
    
    return _orientationComponent;
}

@end
