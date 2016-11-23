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

@class OGRenderComponent;
@class OGPhysicsComponent;
@class OGHealthComponent;

@interface OGBullet : GKEntity <OGResourceLoadable, OGContactNotifiableType>

@property (nonatomic, weak) id<OGEntityManaging> delegate;

@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;
@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGHealthComponent *healthComponent;

@end
