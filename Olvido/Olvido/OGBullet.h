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

@interface OGBullet : GKEntity <OGResourceLoadable, OGContactNotifiableType>

@property (nonatomic, weak) id<OGEntityManaging> delegate;

@property (nonatomic, strong) OGPhysicsComponent *physics;
@property (nonatomic, strong) OGRenderComponent *render;

@end
