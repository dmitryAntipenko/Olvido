//
//  OGAnimationComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 10/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGAnimationComponent.h"
#import "OGAnimationState.h"

CGFloat const kOGAnimationComponentSpeedFactorStop = 0.0;
CGFloat const kOGAnimationComponentSpeedFactorDefault = 1.0;
NSString *const kOGAnimationComponentAnimationActionKey = @"AnimationAction";

@interface OGAnimationComponent ()

@property (nonatomic, retain) OGAnimationState *currentState;
@property (nonatomic, assign, readonly) SKSpriteNode *spriteNode;
@property (nonatomic, assign) SKAction *animationAction;

@end


@implementation OGAnimationComponent

- (void)playNextAnimationState:(OGAnimationState *)nextState
{
    if (nextState && [self.currentState isValidNextState:nextState])
    {
        self.currentState = nextState;
        [self play];
    }
}

- (void)pause
{
    if (self.animationAction)
    {
        self.animationAction.speed = kOGAnimationComponentSpeedFactorStop;
    }
}

- (void)resume
{
    if (self.animationAction)
    {
        self.animationAction.speed = kOGAnimationComponentSpeedFactorDefault;
    }
}

- (void)play
{
    SKSpriteNode *spriteNode = self.spriteNode;
    
    if (spriteNode && self.currentState)
    {
        [spriteNode removeActionForKey:kOGAnimationComponentAnimationActionKey];
        
        if (self.currentState.textures.count > 1)
        {
            SKAction *animationAction = [SKAction animateWithTextures:self.currentState.textures timePerFrame:self.timePerFrame];
            self.animationAction = animationAction;
            
            [spriteNode runAction:[SKAction repeatActionForever:animationAction] withKey:kOGAnimationComponentAnimationActionKey];
        }
        else if (self.currentState.textures.count == 1)
        {
            spriteNode.texture = self.currentState.textures.firstObject;
        }
    }
}

- (SKSpriteNode *)spritenode
{
    return (SKSpriteNode *)(((GKSKNodeComponent *)[self.entity componentForClass:[GKSKNodeComponent class]]).node);
}

- (void)dealloc
{
    [_currentState release];
    
    [super dealloc];
}

@end
