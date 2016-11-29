//
//  OGAnimation.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NSString * OGAnimationState;

@class OGTextureConfiguration;

@interface OGAnimation : NSObject

@property (nonatomic, strong) NSArray<SKTexture *> *textures;
@property (nonatomic, copy) OGAnimationState stateName;
@property (nonatomic, assign, getter=isRepeatedTexturesForever) BOOL repeatTexturesForever;
@property (nonatomic, assign, getter=isPlayingBackwards) BOOL playBackwards;
@property (nonatomic, assign) NSInteger frameOffset;
@property (nonatomic, strong, readonly) NSArray<SKTexture *> *offsetTextures;
@property (nonatomic, assign) NSTimeInterval timePerFrame;
@property (nonatomic, copy) NSString *pairTextureName;

- (instancetype)initWithTextures:(NSArray<SKTexture *> *)textures
                     frameOffset:(NSInteger)frameOffset
           repeatTexturesForever:(BOOL)repeatTexturesForever
                    timePerFrame:(NSTimeInterval)timePerFrame
                       stateName:(NSString *)stateName
                 pairTextureName:(NSString *)pairTextureName
                        backward:(BOOL)backward;

+ (instancetype)animationWithTextures:(NSArray<SKTexture *> *)textures
                          frameOffset:(NSInteger)frameOffset
                repeatTexturesForever:(BOOL)repeatTexturesForever
                         timePerFrame:(NSTimeInterval)timePerFrame
                            stateName:(NSString *)stateName
                      pairTextureName:(NSString *)pairTextureName
                             backward:(BOOL)backward;

+ (instancetype)animationWithTextureConfiguration:(OGTextureConfiguration *)configuration
                             defaultConfiguration:(OGTextureConfiguration *)defaultConfiguration
                                         unitName:(NSString *)unitName;

@end
