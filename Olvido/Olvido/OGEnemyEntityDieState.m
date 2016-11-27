//
//  OGEnemyEntityDieState.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/23/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyEntityDieState.h"
#import "OGEnemyEntity.h"

#import "OGAnimationComponent.h"

#import "OGConstants.h"

@interface OGEnemyEntityDieState () <OGAnimationComponentDelegate>

@property (nonatomic, weak) OGEnemyEntity *enemyEntity;

@property (nonatomic, weak) OGAnimationComponent *animationComponent;

@end

@implementation OGEnemyEntityDieState

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
    self.animationComponent.requestedAnimationState = OGConstantsDead;
}

- (void)animationDidFinish
{
    self.animationComponent.delegate = nil;
    [self.enemyEntity entityDidDie];
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return NO;
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
