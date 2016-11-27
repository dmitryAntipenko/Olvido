//
//  OGAnimationComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 10/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//
#import "OGAnimationComponent.h"
#import "OGAnimation.h"
#import "OGOrientationComponent.h"

NSString *const kOGAnimationComponentTextureActionKey = @"textureActionKey";

@interface OGAnimationComponent ()

@property (nonatomic, assign) NSTimeInterval elapsedAnimationDuration;
@property (nonatomic, strong, readwrite) OGAnimation *currentAnimation;
@property (nonatomic, assign) NSTimeInterval currentTimePerFrame;

@end

@implementation OGAnimationComponent

#pragma mark - Inits

- (instancetype)initWithAnimations:(NSDictionary *)animations
{
    if (animations)
    {
        self = [self init];
        
        if (self)
        {
            _animations = animations;
            _spriteNode = [SKSpriteNode spriteNodeWithTexture:nil];
            _elapsedAnimationDuration = 0.0;
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

#pragma mark - Run Animation

- (void)runAnimationForAnimationState:(NSString *)animationState
                            deltaTime:(NSTimeInterval)deltaTime;
{
    self.elapsedAnimationDuration += deltaTime;

    OGAnimation *animation = self.animations[animationState];
    
    if ((self.currentTimePerFrame != self.currentAnimation.timePerFrame || ![self.currentAnimation.stateName isEqualToString:animation.stateName])
        && self.animations[animationState])
    {
        [self.spriteNode removeActionForKey:kOGAnimationComponentTextureActionKey];
        
        SKAction *texturesAction = nil;
        
        if (animation.textures.count == 1)
        {
            texturesAction = [SKAction setTexture:animation.textures.firstObject resize:YES];
        }
        else
        {
            if (self.currentAnimation && [animation.pairTextureName isEqualToString:self.currentAnimation.stateName])
            {
                NSUInteger numberOfFramesInCurrentAnimation = self.currentAnimation.textures.count;
                NSInteger numberOfFramesPlayedSinceCurrentAnimationBegan = (NSInteger) (self.elapsedAnimationDuration / self.currentAnimation.timePerFrame);
                
                animation.frameOffset = (self.currentAnimation.frameOffset + numberOfFramesPlayedSinceCurrentAnimationBegan + 1) % numberOfFramesInCurrentAnimation;
            }
            
            SKAction *animateAction = [SKAction animateWithTextures:animation.offsetTextures
                                                       timePerFrame:animation.timePerFrame
                                                             resize:YES
                                                            restore:YES];
            if (animation.isRepeatedTexturesForever)
            {
                texturesAction = [SKAction repeatActionForever:animateAction];
            }
            else
            {
                texturesAction = animateAction;
            }
        }
        
        SKAction *complitionAction =  [SKAction runBlock:^()
        {
            self.spriteNode.texture = self.currentAnimation.textures.lastObject;
            self.currentAnimation = nil;
           [self.delegate animationDidFinish];
        }];
        
        [self.spriteNode runAction:[SKAction sequence:@[texturesAction, complitionAction]]
                           withKey:kOGAnimationComponentTextureActionKey];
        
        self.currentAnimation = animation;
        self.currentTimePerFrame = self.currentAnimation.timePerFrame;
        
        self.elapsedAnimationDuration = 0.0;
    }
}

#pragma mark - Updates

- (void)updateWithDeltaTime:(NSTimeInterval)deltaTime
{
    [super updateWithDeltaTime:deltaTime];
    
    if (self.requestedAnimationState)
    {
        [self runAnimationForAnimationState:self.requestedAnimationState deltaTime:deltaTime];
        self.requestedAnimationState = nil;
    }
}

- (void)setRequestedAnimationState:(NSString *)requestedAnimationState
{
    OGOrientationComponent *orientationComponent = (OGOrientationComponent *) [self.entity componentForClass:[OGOrientationComponent class]];
    
    if (orientationComponent)
    {
        _requestedAnimationState = [NSString stringWithFormat:@"%@_%@", requestedAnimationState, orientationComponent.currentOrientation];
    }
    else
    {
        _requestedAnimationState = requestedAnimationState;
    }
}

@end
