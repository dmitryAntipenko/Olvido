//
//  OGDoorEntityLockedState.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDoorEntityLockedState.h"
#import "OGDoorEntityUnlockedState.h"

#import "OGColliderType.h"

#import "OGLockComponent.h"
#import "OGRenderComponent.h"

@implementation OGDoorEntityLockedState

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    self.lockComponent.closed = YES;
    ((SKSpriteNode *) self.renderComponent.node).color = [SKColor blueColor];
    
    SKPhysicsBody *targetPhysicsBody = self.lockComponent.target.physicsBody;
    
    OGColliderType *targetColliderType = [OGColliderType colliderTypeWithCategoryBitMask:targetPhysicsBody.categoryBitMask];
    OGColliderType *doorColliderType = [OGColliderType door];
    NSMutableArray *contactColliders = [OGColliderType definedCollisions][targetColliderType];
    [contactColliders addObject:doorColliderType];
    
    targetPhysicsBody.collisionBitMask = (uint32_t)targetColliderType.collisionBitMask;
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == OGDoorEntityUnlockedState.self;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    if (!self.lockComponent.isLocked)
    {
        if ([self.stateMachine canEnterState:OGDoorEntityUnlockedState.self])
        {
            [self.stateMachine enterState:OGDoorEntityUnlockedState.self];
        }
    }
}

@end
