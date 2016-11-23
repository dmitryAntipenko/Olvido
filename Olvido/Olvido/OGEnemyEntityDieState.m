//
//  OGEnemyEntityDieState.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/23/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyEntityDieState.h"
#import "OGEnemyEntity.h"

#import "OGPhysicsComponent.h"
#import "OGAnimationComponent.h"
#import "OGAnimation.h"

@interface OGEnemyEntityDieState ()

@property (nonatomic, weak) OGEnemyEntity *enemyEntity;

@property (nonatomic, strong) OGAnimationComponent *animationComponent;
@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;

@property (nonatomic, assign) NSTimeInterval elapsedTime;
@end

@implementation OGEnemyEntityDieState

- (instancetype)initWithEnemyEntity:(OGEnemyEntity *)enemyEntity
{
    self = [self init];
    
    if (self)
    {
        _enemyEntity = enemyEntity;
        _elapsedTime = 0.0;
    }
    
    return self;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    self.elapsedTime = 0.0;
    self.animationComponent.requestedAnimationState = kOGAnimationStateDead;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    self.elapsedTime += seconds;

    OGAnimation *animation = self.animationComponent.currentAnimation;
    
    if (animation.animationState == kOGAnimationStateDead)
    {
        NSTimeInterval animationTime = animation.textures.count * animation.timePerFrame;
        
        if (self.elapsedTime >= animationTime)
        {
            [self.enemyEntity entityDidDie];
        }
    }
    
}

- (OGAnimationComponent *)animationComponent
{
    if (!_animationComponent)
    {
        _animationComponent = (OGAnimationComponent *) [self.enemyEntity componentForClass:[OGAnimationComponent class]];
    }
    
    return _animationComponent;
}

- (OGPhysicsComponent *)physicsComponent
{
    if (!_physicsComponent)
    {
        _physicsComponent = (OGPhysicsComponent *) [self.enemyEntity componentForClass:[OGPhysicsComponent class]];
    }
    
    return _physicsComponent;
}

@end
