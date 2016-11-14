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

@class OGRenderComponent;
@class OGAnimationComponent;
@class OGPhysicsComponent;

@interface OGBullet : GKEntity <OGResourceLoadable, OGContactNotifiableType>

@property (nonatomic, strong) OGPhysicsComponent *physics;
@property (nonatomic, strong) OGRenderComponent *render;
//@property (nonatomic, strong) OGAnimationComponent *animation;

@end
