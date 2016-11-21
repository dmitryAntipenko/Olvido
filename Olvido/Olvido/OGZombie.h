//
//  OGZombieMan.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/21/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyEntity.h"
#import "OGResourceLoadable.h"

@class OGAnimationComponent;
@class OGHealthComponent;
@class OGIntelligenceComponent;
@class OGRenderComponent;
@class OGPhysicsComponent;
@class OGOrientationComponent;
@class OGTrailComponent;

@interface OGZombie : OGEnemyEntity <OGResourceLoadable>

@property (nonatomic, strong) OGAnimationComponent *animationComponent;
@property (nonatomic, strong) OGOrientationComponent *orientationComponent;
@property (nonatomic, strong) OGIntelligenceComponent *intelligenceComponent;
@property (nonatomic, strong) OGHealthComponent *healthComponent;
@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;
@property (nonatomic, strong) OGTrailComponent *trailComponent;

+ (NSDictionary *)sOGZombieAnimations;

@end
