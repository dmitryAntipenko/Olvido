//
//  OGEnemyEntityAttackState.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/18/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyEntityAttackState.h"
#import "OGEnemyEntity.h"
#import "OGPlayerEntity.h"

#import "OGAnimationComponent.h"
#import "OGAnimation.h"
#import "OGPhysicsComponent.h"
#import "OGHealthComponent.h"

#import "OGEnemyEntityAgentControlledState.h"
#import "OGEnemyEntityPreAttackState.h"

@interface OGEnemyEntityAttackState ()

@property (nonatomic, weak) OGEnemyEntity *enemyEntity;

@property (nonatomic, weak) OGPhysicsComponent *physicsComponent;
@property (nonatomic, weak) OGAnimationComponent *animationComponent;

@property (nonatomic, assign) CGPoint targetPosition;

@property (nonatomic, assign, getter=isHit) BOOL hit;
@end

@implementation OGEnemyEntityAttackState

- (instancetype)initWithEnemyEntity:(OGEnemyEntity *)enemyEntity
{
    self = [self init];
    
    if (self)
    {
        _enemyEntity = enemyEntity;
        _hit = NO;
        
        vector_float2 targetPosition = self.enemyEntity.huntAgent.position;
        _targetPosition = CGPointMake(targetPosition.x, targetPosition.y);
    }
    
    return self;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    self.hit = NO;
    
    NSArray<SKPhysicsBody*> *contactedBodies = [self.physicsComponent.physicsBody allContactedBodies];
    
    for (SKPhysicsBody *contactedBody in contactedBodies)
    {
        [self applyDamageToEntity:contactedBody.node.entity];
    }
    
    if (self.isHit)
    {
        [self.stateMachine enterState:[OGEnemyEntityPreAttackState class]];
    }
    else
    {
        [self.stateMachine enterState:[OGEnemyEntityAgentControlledState class]];
    }
}

- (void)applyDamageToEntity:(GKEntity *)entity
{
    if ([entity isMemberOfClass:[OGPlayerEntity class]])
    {
        OGHealthComponent *healthComponent = (OGHealthComponent *) [entity componentForClass:[OGHealthComponent class]];
        [healthComponent dealDamage:kOGEnemyEntityDealGamage];
        
        self.hit = YES;
    }
}

#pragma mark - setters
- (OGPhysicsComponent *)physicsComponent
{
    if (!_physicsComponent)
    {
        _physicsComponent = (OGPhysicsComponent *) [self.enemyEntity componentForClass:[OGPhysicsComponent class]];
    }
    
    return _physicsComponent;
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
