//
//  OGDoorEntity.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGContactNotifiableType.h"

@class OGRenderComponent;
@class OGIntelligenceComponent;
@class OGAnimationComponent;
@class OGPhysicsComponent;
@class OGLockComponent;

@interface OGDoorEntity : GKEntity <OGContactNotifiableType>

@property (nonatomic, strong) OGRenderComponent *render;
@property (nonatomic, strong) OGIntelligenceComponent *intelligence;
@property (nonatomic, strong) OGAnimationComponent *animation;
@property (nonatomic, strong) OGPhysicsComponent *physics;
@property (nonatomic, strong) OGLockComponent *lockComponent;

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode NS_DESIGNATED_INITIALIZER;

@end
