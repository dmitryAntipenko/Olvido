//
//  OGAnimationComponent.h
//  Olvido
//
//  Created by Алексей Подолян on 10/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class OGAnimation;

@protocol OGAnimationComponentDelegate <NSObject>

@optional
- (void)animationDidStart;
- (void)animationDidFinish;

@end

@interface OGAnimationComponent : GKComponent

@property (nonatomic, weak) id<OGAnimationComponentDelegate> delegate;

@property (nonatomic, strong) NSDictionary *animations;
@property (nonatomic, strong) SKSpriteNode *spriteNode;
@property (nonatomic, copy) NSString *requestedAnimationState;
@property (nonatomic, strong, readonly) OGAnimation *currentAnimation;

@property (nonatomic, assign, getter=isPlayingBackwards) BOOL playBackwards;

- (instancetype)initWithAnimations:(NSDictionary *)animations;

- (void)runAnimationForAnimationState:(NSString *)animationState
                            deltaTime:(NSTimeInterval)deltaTime;

@end
