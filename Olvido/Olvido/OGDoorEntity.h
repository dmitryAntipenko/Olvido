//
//  OGDoorEntity.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGContactNotifiableType.h"
#import "OGResourceLoadable.h"
#import "OGTransitionComponent.h"
#import "OGTransitionComponentDelegate.h"

@class OGRenderComponent;
@class OGSoundComponent;
@class OGIntelligenceComponent;
@class OGAnimationComponent;
@class OGPhysicsComponent;
@class OGLockComponent;
@class OGTransitionComponent;

@interface OGDoorEntity : GKEntity <OGContactNotifiableType, OGResourceLoadable>

@property (nonatomic, weak) id<OGTransitionComponentDelegate> transitionDelegate;

@property (nonatomic, strong) OGRenderComponent *render;
@property (nonatomic, strong) OGIntelligenceComponent *intelligence;
@property (nonatomic, strong) OGAnimationComponent *animation;
@property (nonatomic, strong) OGPhysicsComponent *physics;
@property (nonatomic, strong) OGLockComponent *lockComponent;
@property (nonatomic, strong) OGTransitionComponent *transition;
@property (nonatomic, strong) OGSoundComponent *sound;

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode;

- (void)lock;
- (void)unlock;

- (void)addKeyName:(NSString *)keyName;
- (void)removeKeyName:(NSString *)keyName;

@end
