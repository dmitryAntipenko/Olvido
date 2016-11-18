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

#import "OGMovementComponent.h"
#import "OGPhysicsComponent.h"
#import "OGHealthComponent.h"

#import "OGEnemyEntityAgentControlledState.h"

@interface OGEnemyEntityAttackState ()

@property (nonatomic, weak) OGEnemyEntity *enemyEntity;

@property (nonatomic, strong) OGMovementComponent *movementComponent;
@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;

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
        [self applyDamageWithEntity:contactedBody.node.entity];
    }
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    if ([self.stateMachine canEnterState:OGEnemyEntityAgentControlledState.self])
    {
        [self.stateMachine enterState:OGEnemyEntityAgentControlledState.self];
    }
}

- (void)applyDamageWithEntity:(GKEntity *)entity
{
    if ([entity isMemberOfClass:OGPlayerEntity.self])
    {
        OGHealthComponent *healthComponent = (OGHealthComponent *) [entity componentForClass:OGHealthComponent.self];
        [healthComponent dealDamage:kOGEnemyEntityDealGamage];
    }
}

#pragma mark - setters
- (OGMovementComponent *)movementComponent
{
    if (!_movementComponent)
    {
        _movementComponent = (OGMovementComponent *) [self.enemyEntity componentForClass:OGMovementComponent.self];
    }
    
    return _movementComponent;
}

- (OGPhysicsComponent *)physicsComponent
{
    if (!_physicsComponent)
    {
        _physicsComponent = (OGPhysicsComponent *) [self.enemyEntity componentForClass:OGPhysicsComponent.self];
    }
    
    return _physicsComponent;
}

@end
