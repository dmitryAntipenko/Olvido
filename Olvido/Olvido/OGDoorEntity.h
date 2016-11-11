//
//  OGDoorEntity.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGContactNotifiableType.h"
#import "OGTransitionComponentDelegate.h"

@class OGRenderComponent;
@class OGIntelligenceComponent;
@class OGAnimationComponent;
@class OGPhysicsComponent;
@class OGLockComponent;
@class OGTransitionComponent;

@interface OGDoorEntity : GKEntity <OGContactNotifiableType>

@property (nonatomic, weak) id<OGTransitionComponentDelegate> transitionDelegate;

@property (nonatomic, strong) OGRenderComponent *render;
@property (nonatomic, strong) OGIntelligenceComponent *intelligence;
@property (nonatomic, strong) OGAnimationComponent *animation;
@property (nonatomic, strong) OGPhysicsComponent *physics;
@property (nonatomic, strong) OGLockComponent *lockComponent;
@property (nonatomic, strong) OGTransitionComponent *transition;

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode NS_DESIGNATED_INITIALIZER;

+ (void)loadResourcesWithCompletionHandler:(void (^)(void))completionHandler;

- (void)lock;
- (void)unlock;

@end
