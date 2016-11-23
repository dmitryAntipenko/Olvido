//
//  OGPlayerEntity.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class OGPlayerConfiguration;
@class OGShadowComponent;
@class OGInventoryComponent;
@class OGWeaponComponent;
@class OGHealthComponent;
@class OGAnimationComponent;
@class OGIntelligenceComponent;
@class OGInputComponent;
@class OGRenderComponent;
@class OGMovementComponent;
@class OGPhysicsComponent;
@class OGMessageComponent;
@class OGOrientationComponent;

@interface OGPlayerEntity : GKEntity

@property (nonatomic, strong) OGShadowComponent *shadowComponent;
@property (nonatomic, strong) OGInventoryComponent *inventoryComponent;
@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;
@property (nonatomic, strong) OGInputComponent *inputComponent;
@property (nonatomic, strong) OGIntelligenceComponent *intelligenceComponent;
@property (nonatomic, strong) OGHealthComponent *healthComponent;
@property (nonatomic, strong) OGAnimationComponent *animationComponent;
@property (nonatomic, strong) OGMovementComponent *movementComponent;
@property (nonatomic, strong) OGMessageComponent *messageComponent;
@property (nonatomic, strong) OGOrientationComponent *orientationComponent;
@property (nonatomic, strong) OGWeaponComponent *weaponComponent;
@property (nonatomic, strong) GKAgent2D *agent;

- (instancetype)initWithConfiguration:(OGPlayerConfiguration *)configuration;

- (void)updateAgentPositionToMatchNodePosition;

@end
