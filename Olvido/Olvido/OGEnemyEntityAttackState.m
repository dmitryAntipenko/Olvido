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

@interface OGEnemyEntityAttackState ()

@property (nonatomic, weak) OGEnemyEntity *enemyEntity;

@property (nonatomic, weak) OGPhysicsComponent *physicsComponent;
@property (nonatomic, weak) OGAnimationComponent *animationComponent;

@property (nonatomic, assign) CGPoint targetPosition;

@end

@implementation OGEnemyEntityAttackState

- (instancetype)initWithEnemyEntity:(OGEnemyEntity *)enemyEntity
{
    self = [self init];
    
    if (self)
    {
        _enemyEntity = enemyEntity;
        
        vector_float2 targetPosition = self.enemyEntity.huntAgent.position;
        _targetPosition = CGPointMake(targetPosition.x, targetPosition.y);
    }
    
    return self;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    NSArray<SKPhysicsBody*> *contactedBodies = [self.physicsComponent.physicsBody allContactedBodies];
    
    for (SKPhysicsBody *contactedBody in contactedBodies)
    {
        [self applyDamageToEntity:contactedBody.node.entity];
    }
}

- (void)applyDamageToEntity:(GKEntity *)entity
{
    if ([entity isMemberOfClass:[OGPlayerEntity class]])
    {
        OGHealthComponent *healthComponent = (OGHealthComponent *) [entity componentForClass:[OGHealthComponent class]];
        [healthComponent dealDamage:kOGEnemyEntityDealGamage];
    }
}

#pragma mark - Setters

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
