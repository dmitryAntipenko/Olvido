//
//  OGPlayerEntity.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class OGRenderComponent;
@class OGPlayerConfiguration;

@interface OGPlayerEntity : GKEntity

@property (nonatomic, strong, readonly) OGRenderComponent *renderComponent;

- (instancetype)initWithConfiguration:(OGPlayerConfiguration *)configuration;

- (void)updateAgentPositionToMatchNodePosition;

@end
