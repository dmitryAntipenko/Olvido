//
//  OGAnimation.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGAnimation.h"

@implementation OGAnimation

- (instancetype)initWithAnimationState:(OGAnimationState)animationState
                             direction:(OGDirection)direction
                              textures:(NSArray<SKTexture *> *)textures
                           frameOffset:(NSInteger)frameOffset
                 repeatTexturesForever:(BOOL)repeatTexturesForever
                        bodyActionName:(NSString *)bodyActionName
                            bodyAction:(SKAction *)bodyAction
{
    self = [super init];
    
    if (self)
    {
        _animationState = animationState;
        _direction = direction;
        _textures = textures;
        _frameOffset = frameOffset;
        _repeatTexturesForever = repeatTexturesForever;
        _bodyActionName = bodyActionName;
        _bodyAction = bodyAction;
    }
    
    return self;
}

+ (instancetype)animationWithAnimationState:(OGAnimationState)animationState
                                  direction:(OGDirection)direction
                                   textures:(NSArray<SKTexture *> *)textures
                                frameOffset:(NSInteger)frameOffset
                      repeatTexturesForever:(BOOL)repeatTexturesForever
                             bodyActionName:(NSString *)bodyActionName
                                 bodyAction:(SKAction *)bodyAction
{
    return [[OGAnimation alloc] initWithAnimationState:animationState
                                             direction:direction
                                              textures:textures
                                           frameOffset:frameOffset
                                 repeatTexturesForever:repeatTexturesForever
                                        bodyActionName:bodyActionName
                                            bodyAction:bodyAction];
}

- (NSArray<SKTexture *> *)offsetTextures
{
    NSMutableArray<SKTexture *> *result = nil;
    
    if (self.frameOffset == 0)
    {
        result = [NSMutableArray arrayWithArray:self.textures];
    }
    else
    {
        result = [NSMutableArray array];
        
        for (NSUInteger i = self.frameOffset; i < self.textures.count; i++)
        {
            [result addObject:self.textures[i]];
        }
        
        for (NSUInteger i = 0; i < self.frameOffset; i++)
        {
            [result addObject:self.textures[i]];
        }
    }
    
    return result;
}
@end
