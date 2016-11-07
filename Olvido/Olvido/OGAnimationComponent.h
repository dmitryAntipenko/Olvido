//
//  OGAnimationComponent.h
//  Olvido
//
//  Created by Алексей Подолян on 10/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGAnimationState.h"
#import "OGDirection.h"

@class OGAnimation;

@interface OGAnimationComponent : GKComponent

@property (nonatomic, strong, readonly) NSDictionary *animations;
@property (nonatomic, strong) SKSpriteNode *spriteNode;
@property (nonatomic, assign) OGAnimationState requestedAnimationState;

- (instancetype)initWithTextureSize:(CGSize)textureSize
                         animations:(NSDictionary *)animations;

- (void)runAnimationForAnimationStateWithAnimationState:(OGAnimationState)animationState
                                              deltaTime:(CGFloat)deltaTime;

@end
