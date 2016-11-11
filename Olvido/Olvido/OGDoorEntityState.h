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

@interface OGDoorEntityState : GKState

@property (nonatomic, strong) OGDoorEntity *doorEntity;

@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGLockComponent *lockComponent;

- (instancetype)initWithDoorEntity:(OGDoorEntity *)entity;

@end
