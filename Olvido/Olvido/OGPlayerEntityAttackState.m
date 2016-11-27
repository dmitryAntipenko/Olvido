//
//  OGPlayerEntityAttackState.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerEntityAttackState.h"
#import "OGPlayerEntityControlledState.h"

#import "OGAnimationComponent.h"

#import "OGPlayerEntity.h"

CGFloat const OGPlayerEntityAttackStateAttackDuration = 3.0;

@interface OGPlayerEntityAttackState ()

@property (nonatomic, weak) OGPlayerEntity *playerEntity;

@property (nonatomic, strong) OGAnimationComponent *animationComponent;

@property (nonatomic, assign) NSTimeInterval elapsedTime;

@end

@implementation OGPlayerEntityAttackState

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _elapsedTime = 0.0;
    }
    
    return self;
}

- (instancetype)initWithPlayerEntity:(OGPlayerEntity *)playerEntity
{
    self = [self init];
    
    if (self)
    {
        _playerEntity = playerEntity;
    }
    
    return self;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    self.elapsedTime = 0.0;
    
    self.animationComponent.requestedAnimationState = OGAnimationStateAttack;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    self.elapsedTime += seconds;
    
    if (self.elapsedTime > OGPlayerEntityAttackStateAttackDuration)
    {
        if ([self.stateMachine canEnterState:[OGPlayerEntityControlledState class]])
        {
            [self.stateMachine enterState:[OGPlayerEntityControlledState class]];
        }
    }
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [OGPlayerEntityControlledState class];
}

- (OGAnimationComponent *)animationComponent
{
    if (!_animationComponent)
    {
        _animationComponent = (OGAnimationComponent *) [self.playerEntity componentForClass:[OGAnimationComponent class]];
    }
    
    return _animationComponent;
}

@end
