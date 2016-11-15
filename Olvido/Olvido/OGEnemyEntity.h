//
//  OGEnemyEntity.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGContactNotifiableType.h"
#import "OGResourceLoadable.h"

@class OGEnemyConfiguration;
@class OGHealthComponent;
@class OGAnimationComponent;
@class OGIntelligenceComponent;
@class OGRenderComponent;
@class OGMovementComponent;
@class OGPhysicsComponent;

typedef NS_ENUM(NSUInteger, OGEnemyEntityMandate)
{
    kOGEnemyEntityMandateFollowPath = 0,
    kOGEnemyEntityMandateHunt,
    kOGEnemyEntityMandateAttack
};

@interface OGEnemyEntity : GKEntity <OGResourceLoadable, OGContactNotifiableType>

@property (nonatomic, strong) OGRenderComponent *render;
@property (nonatomic, strong) OGPhysicsComponent *physics;
@property (nonatomic, strong) OGHealthComponent *health;
@property (nonatomic, strong) OGAnimationComponent *animation;
@property (nonatomic, strong) OGMovementComponent *movement;
@property (nonatomic, strong) OGIntelligenceComponent *intelligence;

@property (nonatomic, strong) GKAgent2D *agent;

+ (CGSize)textureSize;

+ (NSDictionary *)sOGEnemyEntityAnimations;

//- (instancetype)initWithPoints:(NSArray<NSValue *> *)points NS_DESIGNATED_INITIALIZER;

- (CGFloat)distanceToAgentWithOtherAgent:(GKAgent2D *)otherAgent;

- (instancetype)initWithConfiguration:(OGEnemyConfiguration *)configuration;

@end
