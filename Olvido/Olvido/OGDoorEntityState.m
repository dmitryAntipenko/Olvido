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

@implementation OGDoorEntityState

- (instancetype)initWithDoorEntity:(OGDoorEntity *)entity
{
    self = [super init];
    
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
        _lockComponent = (OGLockComponent *) [self.doorEntity componentForClass:OGLockComponent.self];
    }
    
    return _lockComponent;
}

- (OGRenderComponent *)renderComponent
{
    if (!_renderComponent)
    {
        _renderComponent = (OGRenderComponent *) [self.doorEntity componentForClass:OGRenderComponent.self];
    }
    
    return _renderComponent;
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
