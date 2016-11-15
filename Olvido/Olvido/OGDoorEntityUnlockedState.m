//
//  OGDoorEntityUnlockedState.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDoorEntityUnlockedState.h"
#import "OGDoorEntityClosedState.h"

#import "OGColliderType.h"

#import "OGLockComponent.h"
#import "OGRenderComponent.h"

@implementation OGDoorEntityUnlockedState

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    self.lockComponent.closed = NO;
    ((SKSpriteNode *) self.renderComponent.node).color = [SKColor blueColor];
    
    SKPhysicsBody *targetPhysicsBody = self.lockComponent.target.physicsBody;
    
    OGColliderType *targetColliderType = [OGColliderType colliderTypeWithCategoryBitMask:targetPhysicsBody.categoryBitMask];
    OGColliderType *doorColliderType = [OGColliderType door];
    [[OGColliderType definedCollisions][targetColliderType] removeObject:doorColliderType];
    
    targetPhysicsBody.collisionBitMask = (uint32_t)targetColliderType.collisionBitMask;
    
    if ([self.stateMachine canEnterState:OGDoorEntityClosedState.self])
    {
        [self.stateMachine enterState:OGDoorEntityClosedState.self];
    }
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == OGDoorEntityClosedState.self;
}

@end
