//
//  OGPlayerEntity.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGEntityManaging.h"

@class OGRenderComponent;
@class OGPlayerConfiguration;

@interface OGPlayerEntity : GKEntity

@property (nonatomic, strong, readonly) OGRenderComponent *renderComponent;
@property (nonatomic, weak) id<OGEntityManaging> delegate;

@property (nonatomic, strong, readonly) GKAgent2D *agent;

- (instancetype)initWithConfiguration:(OGPlayerConfiguration *)configuration;

- (void)updateAgentPositionToMatchNodePosition;
- (void)entityDidDie;

@end
