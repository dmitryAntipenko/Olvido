//
//  OGPlayerEntity.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGResourceLoadable.h"

@class OGHealthComponent;
@class OGAnimationComponent;
@class OGIntelligenceComponent;
@class OGInputComponent;
@class OGRenderComponent;
@class OGMovementComponent;
@class OGPhysicsComponent;
@class OGMessageComponent;
@class OGOrientationComponent;

@interface OGPlayerEntity : GKEntity <OGResourceLoadable>

@property (nonatomic, strong) OGRenderComponent *render;
@property (nonatomic, strong) OGPhysicsComponent *physics;
@property (nonatomic, strong) OGInputComponent *input;
@property (nonatomic, strong) OGIntelligenceComponent *intelligence;
@property (nonatomic, strong) OGHealthComponent *health;
@property (nonatomic, strong) OGAnimationComponent *animation;
@property (nonatomic, strong) OGMovementComponent *movement;
@property (nonatomic, strong) OGMessageComponent *messageComponent;
@property (nonatomic, strong) OGOrientationComponent *orientation;

+ (void)loadResourcesWithCompletionHandler:(void (^)(void))completionHandler;

+ (NSDictionary *)sOGPlayerEntityAnimations;
+ (NSDictionary *)sOGPlayerEntityAppearTextures;
+ (CGSize)textureSize;

@end
