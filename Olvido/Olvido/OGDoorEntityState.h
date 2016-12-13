//
//  OGDoorEntityState.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class OGDoorEntity;
@class OGLockComponent;
@class OGRenderComponent;
@class OGPhysicsComponent;

@interface OGDoorEntityState : GKState

@property (nonatomic, weak) OGDoorEntity *doorEntity;

@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGLockComponent *lockComponent;
@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;

- (instancetype)initWithDoorEntity:(OGDoorEntity *)entity;

- (BOOL)isTargetNearDoor;

@end
