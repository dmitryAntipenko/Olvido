//
//  OGAnimation.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGAnimation.h"
#import "OGTextureConfiguration.h"
#import "OGTextureAtlasesManager.h"

@implementation OGAnimation

#pragma mark - Initializers

- (instancetype)initWithTextures:(NSArray<SKTexture *> *)textures
                     frameOffset:(NSInteger)frameOffset
           repeatTexturesForever:(BOOL)repeatTexturesForever
                    timePerFrame:(NSTimeInterval)timePerFrame
                       stateName:(NSString *)stateName
                 pairTextureName:(NSString *)pairTextureName
{
    self = [self init];
    
    if (self)
    {
        _textures = textures;
        _frameOffset = frameOffset;
        _repeatTexturesForever = repeatTexturesForever;
        _timePerFrame = timePerFrame;
        _stateName = stateName;
    }
    
    return self;
}

+ (instancetype)animationWithTextures:(NSArray<SKTexture *> *)textures
                          frameOffset:(NSInteger)frameOffset
                repeatTexturesForever:(BOOL)repeatTexturesForever
                         timePerFrame:(NSTimeInterval)timePerFrame
                            stateName:(NSString *)stateName
                      pairTextureName:(NSString *)pairTextureName
{
    return [[OGAnimation alloc] initWithTextures:textures
                                     frameOffset:frameOffset
                           repeatTexturesForever:repeatTexturesForever
                                    timePerFrame:timePerFrame
                                       stateName:stateName
                                 pairTextureName:pairTextureName];
}

+ (instancetype)animationWithTextureConfiguration:(OGTextureConfiguration *)configuration
                             defaultConfiguration:(OGTextureConfiguration *)defaultConfiguration
                                         unitName:(NSString *)unitName
{
    NSString *textureName = configuration.textureName ? configuration.textureName : defaultConfiguration.textureName;
    NSString *pairTextureName = configuration.pairTextureName ? configuration.pairTextureName : defaultConfiguration.pairTextureName;
        
    CGFloat timePerFrame = configuration.timePerFrame;
    BOOL repeatForever = configuration.repeatForever;
    
    SKTextureAtlas *atlas = [[OGTextureAtlasesManager sharedInstance] atlasWithUnitName:unitName atlasKey:textureName];
    
    NSSortDescriptor *backwardsSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:!repeatForever];
    NSArray<NSString *> *filteredTextureNames = [atlas.textureNames sortedArrayUsingDescriptors:@[backwardsSortDescriptor]];
    
    NSArray<SKTexture *> *textures = [self mapWithArrayOfStrings:filteredTextureNames];
    
    return  [OGAnimation animationWithTextures:textures
                                   frameOffset:0
                         repeatTexturesForever:repeatForever
                                  timePerFrame:timePerFrame
                                     stateName:textureName
                               pairTextureName:pairTextureName];
}

#pragma mark -

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
