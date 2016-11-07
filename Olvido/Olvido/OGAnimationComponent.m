//
//  OGAnimationComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 10/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGAnimationComponent.h"
//#import "OGAnimationState.h"
#import "OGAnimation.h"

//CGFloat const kOGAnimationComponentSpeedFactorStop = 0.0;
//CGFloat const kOGAnimationComponentSpeedFactorDefault = 1.0;
//NSString *const kOGAnimationComponentAnimationActionKey = @"AnimationAction";


NSString *const kOGAnimationComponentBodyActionKey = @"bodyAction";
NSString *const kOGAnimationComponentTextureActionKey = @"textureActionKey";
CGFloat const kOGAnimationComponentTimePerFrame = 0.1;

@interface OGAnimationComponent ()

//@property (nonatomic, strong) OGAnimationState *currentState;
//@property (nonatomic, weak, readonly) SKSpriteNode *spriteNode;
//@property (nonatomic, weak) SKAction *animationAction;

@property (nonatomic, strong) OGAnimation *currentAnimation;
@property (nonatomic, assign) NSTimeInterval elapsedAnimationDuration;
@end


@implementation OGAnimationComponent

//- (void)playNextAnimationState:(OGAnimationState *)nextState
//{
//    if (nextState && (!self.currentState || [self.currentState isValidNextState:nextState]))
//    {
//        self.currentState = nextState;
//        [self play];
//    }
//}

- (instancetype)initWithTextureSize:(CGSize)textureSize
                         animations:(NSDictionary *)animations
{
    self = [super init];
    
    if (self)
    {
        _animations = animations;
        _spriteNode = [SKSpriteNode spriteNodeWithTexture:nil size:textureSize];
        _elapsedAnimationDuration = 0.0;
    }
    
    return self;
}

- (void)runAnimationForAnimationStateWithAnimationState:(OGAnimationState)animationState
                                           deltaTime:(NSTimeInterval)deltaTime
{
    self.elapsedAnimationDuration += deltaTime;
    
    if (self.currentAnimation == nil && self.currentAnimation.animationState != animationState
        && self.animations[kOGAnimationStateDescription[animationState]])
    {
        OGAnimation *animation = self.animations[kOGAnimationStateDescription[animationState]];
        
        if (![self.currentAnimation.bodyActionName isEqualToString:animation.bodyActionName])
        {
            [self.spriteNode removeActionForKey:kOGAnimationComponentBodyActionKey];
            self.spriteNode.position = CGPointZero;
            
            SKAction *bodyAction = animation.bodyAction;
            
            if (bodyAction)
            {
                [self.spriteNode runAction:[SKAction repeatActionForever:bodyAction] withKey:kOGAnimationComponentBodyActionKey];
            }
        }
        
        [self.spriteNode removeActionForKey:kOGAnimationComponentTextureActionKey];
        
        SKAction *texturesAction = nil;
        
        if ([animation.textures count] == 1)
        {
            texturesAction = [SKAction setTexture:animation.textures.firstObject];
        }
        else
        {
            if (self.currentAnimation && animationState == self.currentAnimation.animationState)
            {
                NSUInteger numberOfFramesInCurrentAnimation = self.currentAnimation.textures.count;
                NSInteger numberOfFramesPlayedSinceCurrentAnimationBegan = (NSInteger) (self.elapsedAnimationDuration / kOGAnimationComponentTimePerFrame);
                
                animation.frameOffset = (self.currentAnimation.frameOffset + numberOfFramesPlayedSinceCurrentAnimationBegan + 1) % numberOfFramesInCurrentAnimation;
            }
            
            SKAction *animateAction = [SKAction animateWithTextures:animation.offsetTextures timePerFrame:kOGAnimationComponentTimePerFrame];
            if (animation.isRepeatedTexturesForever)
            {
                texturesAction = [SKAction repeatActionForever:animateAction];
            }
            else
            {
                texturesAction = animateAction;
            }
        }
        
        [self.spriteNode runAction:texturesAction withKey:kOGAnimationComponentTextureActionKey];
        
        self.currentAnimation = animation;
        
        self.elapsedAnimationDuration = 0.0;
    }
}

- (void)updateWithDeltaTime:(NSTimeInterval)deltaTime
{
    [super updateWithDeltaTime:deltaTime];
    
    if (self.requestedAnimationState != OGAnimationStateNone)
    {
        [self runAnimationForAnimationStateWithAnimationState:self.requestedAnimationState deltaTime:deltaTime];
        self.requestedAnimationState = OGAnimationStateNone;
    }
}


//- (void)pause
//{
//    if (self.animationAction)
//    {
//        self.animationAction.speed = kOGAnimationComponentSpeedFactorStop;
//    }
//}
//
//- (void)resume
//{
//    if (self.animationAction)
//    {
//        self.animationAction.speed = kOGAnimationComponentSpeedFactorDefault;
//    }
//}
//
//- (void)play
//{
//    SKSpriteNode *spriteNode = self.spriteNode;
//    
//    if (spriteNode && self.currentState)
//    {
//        [spriteNode removeActionForKey:kOGAnimationComponentAnimationActionKey];
//        
//        if (self.currentState.textures.count > 1)
//        {
//            SKAction *animationAction = [SKAction animateWithTextures:self.currentState.textures timePerFrame:self.timePerFrame];
//            self.animationAction = animationAction;
//            
//            [spriteNode runAction:[SKAction repeatActionForever:animationAction] withKey:kOGAnimationComponentAnimationActionKey];
//        }
//        else if (self.currentState.textures.count == 1)
//        {
//            spriteNode.texture = self.currentState.textures.firstObject;
//        }
//    }
//}
//
//- (SKSpriteNode *)spriteNode
//{
//    return (SKSpriteNode *)(((GKSKNodeComponent *)[self.entity componentForClass:[GKSKNodeComponent class]]).node);
//}


@end
