//
//  OGEnemyEntity.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class OGHealthComponent;
@class OGAnimationComponent;
@class OGIntelligenceComponent;
@class OGRenderComponent;
@class OGMovementComponent;
@class OGPhysicsComponent;

@interface OGEnemyEntity : GKEntity

@property (nonatomic, strong) OGRenderComponent *render;
@property (nonatomic, strong) OGPhysicsComponent *physics;
@property (nonatomic, strong) OGHealthComponent *health;
@property (nonatomic, strong) OGAnimationComponent *animation;
@property (nonatomic, strong) OGMovementComponent *movement;
@property (nonatomic, strong) OGIntelligenceComponent *intelligence;

@end
