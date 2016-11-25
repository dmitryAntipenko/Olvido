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

@protocol OGAnimationComponentDelegate <NSObject>

- (void)animationDidFinish;

@end

@interface OGAnimationComponent : GKComponent

@property (nonatomic, weak) id<OGAnimationComponentDelegate> delegate;

@property (nonatomic, strong) NSDictionary *animations;
@property (nonatomic, strong) SKSpriteNode *spriteNode;
@property (nonatomic, assign) OGAnimationState requestedAnimationState;
@property (nonatomic, strong, readonly) OGAnimation *currentAnimation;

- (instancetype)initWithAnimations:(NSDictionary *)animations;

- (void)runAnimationForAnimationStateWithAnimationState:(OGAnimationState)animationState
                                              direction:(OGDirection)direction
                                              deltaTime:(NSTimeInterval)deltaTime;

+ (SKTexture *)firstTextureForOrientationWithDirection:(OGDirection)direction
                                                 atlas:(SKTextureAtlas *)atlas
                                       imageIdentifier:(NSString *)imageIdentifier;

+ (NSDictionary *)animationsWithAtlas:(SKTextureAtlas *)atlas
                       animationState:(OGAnimationState)animationState
                       bodyActionName:(NSString *)bodyActionName
                repeatTexturesForever:(BOOL)repeatTexturesForever
                        playBackwards:(BOOL)playBackwards
                         timePerFrame:(NSTimeInterval)timePerFrame
                      imageIdentifier:(NSString *)imageIdentifier;
@end
