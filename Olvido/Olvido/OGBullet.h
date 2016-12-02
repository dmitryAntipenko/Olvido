//
//  OGBullet.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/13/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGContactNotifiableType.h"
#import "OGResourceLoadable.h"
#import "OGEntityManaging.h"

@class OGPhysicsComponent;
@class OGRenderComponent;
@class OGShellConfiguration;

@interface OGBullet : GKEntity <OGResourceLoadable, OGContactNotifiableType>

@property (nonatomic, weak) id<OGEntityManaging> delegate;

@property (nonatomic, strong, readonly) OGPhysicsComponent *physicsComponent;
@property (nonatomic, strong, readonly) OGRenderComponent *renderComponent;

@property (nonatomic, assign, readonly) CGFloat speed;

- (instancetype)initWithConfiguration:(OGShellConfiguration *)configuration;

@end
