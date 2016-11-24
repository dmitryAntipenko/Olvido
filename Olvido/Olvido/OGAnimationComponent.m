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

NSString *const kOGAnimationComponentBodyActionKey = @"bodyAction";
NSString *const kOGAnimationComponentTextureActionKey = @"textureActionKey";
CGFloat const kOGAnimationComponentTimePerFrame = 0.1;

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
- (void)runAnimationForAnimationStateWithAnimationState:(OGAnimationState)animationState
                                              direction:(OGDirection)direction
                                           deltaTime:(NSTimeInterval)deltaTime
{
    self.elapsedAnimationDuration += deltaTime;
    
    if ((self.currentAnimation == nil || self.currentAnimation.animationState != animationState
         || self.currentAnimation.direction != direction || self.currentTimePerFrame != self.currentAnimation.timePerFrame)
        && self.animations[kOGAnimationStateDescription[animationState]][kOGDirectionDescription[direction]])
    {
        OGAnimation *animation = self.animations[kOGAnimationStateDescription[animationState]][kOGDirectionDescription[direction]];
        
        if (self.currentAnimation && ![self.currentAnimation.bodyActionName isEqualToString:animation.bodyActionName])
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
        
        if (animation.textures.count == 1)
        {
            texturesAction = [SKAction setTexture:animation.textures.firstObject resize:YES];
        }
        else
        {
            if (self.currentAnimation && animationState == self.currentAnimation.animationState)
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
    
    if (self.requestedAnimationState != kOGAnimationStateNone)
    {
        OGOrientationComponent *orientationComponent = (OGOrientationComponent *) [self.entity componentForClass:[OGOrientationComponent class]];
        
        if (orientationComponent)
        {
            [self runAnimationForAnimationStateWithAnimationState:self.requestedAnimationState direction:orientationComponent.direction deltaTime:deltaTime];
            self.requestedAnimationState = kOGAnimationStateNone;
        }
    }
}

#pragma mark - Class Methods
+ (SKTexture *)firstTextureForOrientationWithDirection:(OGDirection)direction
                                                 atlas:(SKTextureAtlas *)atlas
                                       imageIdentifier:(NSString *)imageIdentifier
{
    NSString *structure = [NSString stringWithFormat:@"%@_%lu_", imageIdentifier, (unsigned long)direction];
    NSString *filter = @"SELF BEGINSWITH %@";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:filter, structure];
    
    NSArray<NSString *> *sortedTextureNames = [[[atlas textureNames] filteredArrayUsingPredicate:predicate] sortedArrayUsingSelector:@selector(localizedCompare:)];
    
    return [atlas textureNamed:sortedTextureNames.firstObject];
}

+ (NSArray<SKTexture *> *)mapWithArrayOfStrings:(NSArray<NSString *> *)arrayOfStrings
{
    NSMutableArray<SKTexture *> *result = [NSMutableArray array];
    
    for (NSString *imageName in arrayOfStrings)
    {
        SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
        
        [result addObject:texture];
    }
    
    return result;
}

+ (SKAction *)actionForAllTexturesWithAtlas:(SKTextureAtlas *)atlas
{
    NSArray<NSString *> *sortedTextureNames = [[atlas textureNames] sortedArrayUsingSelector:@selector(localizedCompare:)];
    NSArray<SKTexture *> *sortedTextures = [self mapWithArrayOfStrings:sortedTextureNames];
    
    SKAction *result = nil;
    
    if (sortedTextures.count == 1)
    {
        result = [SKAction setTexture:sortedTextures.firstObject];
    }
    else
    {
        SKAction *texturesAction = [SKAction animateWithTextures:sortedTextures timePerFrame:kOGAnimationComponentTimePerFrame];
        result = [SKAction repeatActionForever:texturesAction];
    }
    
    return result;
}

+ (NSDictionary *)animationsWithAtlas:(SKTextureAtlas *)atlas
                       animationState:(OGAnimationState)animationState
                       bodyActionName:(NSString *)bodyActionName
                 repeatTexturesForever:(BOOL)repeatTexturesForever
                        playBackwards:(BOOL)playBackwards
                         timePerFrame:(NSTimeInterval)timePerFrame
                            atlasName:(NSString *)atlasName
{
    SKAction *bodyAction = nil;
    if (bodyActionName)
    {
        bodyAction = [SKAction actionNamed:bodyActionName];
    }
    
    NSMutableDictionary *animations = [NSMutableDictionary dictionary];

    NSString *structure = [NSString stringWithFormat:@"%@_", atlasName];
    NSString *filter = @"SELF BEGINSWITH %@";

    NSPredicate *predicate = [NSPredicate predicateWithFormat:filter, structure];
    NSArray<NSString *> *filteredTextureNames = [[atlas textureNames] filteredArrayUsingPredicate:predicate];

    NSSortDescriptor *backwardsSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:!playBackwards];
    filteredTextureNames = [filteredTextureNames sortedArrayUsingDescriptors:@[backwardsSortDescriptor]];
        
    NSArray<SKTexture *> *textures = [self mapWithArrayOfStrings:filteredTextureNames];
    
    OGDirection directin;
    
    NSString *directionIdentifier = [atlasName substringFromIndex:atlasName.length];
    
    if ([directionIdentifier isEqualToString:@"R"])
    {
        directin = kOGDirectionRight;
    }
    else if ([directionIdentifier isEqualToString:@"L"])
    {
        directin = kOGDirectionLeft;
    }
        
    animations[atlasName] = [OGAnimation animationWithAnimationState:animationState
                                                           direction:directin
                                                            textures:textures
                                                         frameOffset:0
                                               repeatTexturesForever:repeatTexturesForever
                                                      bodyActionName:bodyActionName
                                                          bodyAction:bodyAction
                                                        timePerFrame:timePerFrame];

    
    return animations;
}

@end
