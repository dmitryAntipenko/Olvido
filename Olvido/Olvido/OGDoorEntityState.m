//
//  OGDoorEntityState.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDoorEntityState.h"
#import "OGDoorEntity.h"
#import "OGLockComponent.h"
#import "OGRenderComponent.h"
#import "OGPhysicsComponent.h"

@implementation OGDoorEntityState

- (instancetype)initWithDoorEntity:(OGDoorEntity *)entity
{
    self = [self init];
    
    if (self)
    {
        _doorEntity = entity;
    }
    
    return self;
}

- (OGLockComponent *)lockComponent
{
    if (!_lockComponent)
    {
        _lockComponent = (OGLockComponent *) [self.doorEntity componentForClass:[OGLockComponent class]];
    }
    
    return _lockComponent;
}

- (OGRenderComponent *)renderComponent
{
    if (!_renderComponent)
    {
        _renderComponent = (OGRenderComponent *) [self.doorEntity componentForClass:[OGRenderComponent class]];
    }
    
    return _renderComponent;
}

- (OGPhysicsComponent *)physicsComponent
{
    if (!_physicsComponent)
    {
        _physicsComponent = (OGPhysicsComponent *) [self.doorEntity componentForClass:[OGPhysicsComponent class]];
    }
    
    return _physicsComponent;
}

- (BOOL)isTargetNearDoor
{
    CGRect targetRect = self.lockComponent.target.calculateAccumulatedFrame;
    CGRect doorNodeRect = self.renderComponent.node.calculateAccumulatedFrame;
    CGFloat minOpenDistance = self.lockComponent.openDistance;
    
    CGRect enlargedTargetRect = CGRectInset(targetRect, -minOpenDistance, -minOpenDistance);
    
    return CGRectIntersectsRect(enlargedTargetRect, doorNodeRect);
}

@end
