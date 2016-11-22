//
//  OGAnimation.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGAnimationState.h"
#import "OGDirection.h"

@interface OGAnimation : NSObject

@property (nonatomic, strong) NSString *bodyActionName;
@property (nonatomic, strong) NSArray<SKTexture *> *textures;
@property (nonatomic, assign) OGAnimationState animationState;
@property (nonatomic, assign, getter=isRepeatedTexturesForever) BOOL repeatTexturesForever;
@property (nonatomic, assign) NSInteger frameOffset;
@property (nonatomic, strong) SKAction *bodyAction;
@property (nonatomic, strong, readonly) NSArray<SKTexture *> *offsetTextures;
@property (nonatomic, assign) OGDirection direction;
@property (nonatomic, assign) NSTimeInterval timePerFrame;

- (instancetype)initWithAnimationState:(OGAnimationState)animationState
                             direction:(OGDirection)direction
                              textures:(NSArray<SKTexture *> *)textures
                           frameOffset:(NSInteger)frameOffset
                 repeatTexturesForever:(BOOL)repeatTexturesForever
                        bodyActionName:(NSString *)bodyActionName
                            bodyAction:(SKAction *)bodyAction
                          timePerFrame:(NSTimeInterval)timePerFrame;

+ (instancetype)animationWithAnimationState:(OGAnimationState)animationState
                                  direction:(OGDirection)direction
                                   textures:(NSArray<SKTexture *> *)textures
                                frameOffset:(NSInteger)frameOffset
                      repeatTexturesForever:(BOOL)repeatTexturesForever
                             bodyActionName:(NSString *)bodyActionName
                                 bodyAction:(SKAction *)bodyAction
                               timePerFrame:(NSTimeInterval)timePerFrame;
@end
