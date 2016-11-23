//
//  OGTextureManager.m
//  Olvido
//
//  Created by Алексей Подолян on 11/23/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTextureManager.h"

@interface OGTextureManager ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSDictionary<NSString *, NSArray<SKTexture *> *> *> *textures;

@end

@implementation OGTextureManager

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _textures = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

+ (instancetype)textureManager
{
    return [[self alloc] init];
}

#pragma mark - Memory managment

- (void)loadAtlasesWithUnitName:(NSString *)unitName atlasName:(NSString *)atlasName
{
    if (unitName && atlasName)
    {
        NSMutableDictionary *atlases = [[self.textures objectForKey:unitName] mutableCopy];
        
        if (!atlases)
        {
            atlases = [[NSMutableDictionary alloc] init];
        }
        
        SKTextureAtlas *atlas = [atlases objectForKey:atlasName];
        
        if (!atlas)
        {
            atlas = [SKTextureAtlas atlasNamed:atlasName];
            [atlas preloadWithCompletionHandler:^{}];
            
            NSMutableArray *atlasTextures = [[NSMutableArray alloc] init];
            
            for (NSString *textureName in atlas.textureNames)
            {
                [atlasTextures addObject:[atlas textureNamed:textureName]];
            }
            
            [atlases setObject:atlasTextures forKey:atlasName];
        }
        
        [self.textures setObject:[atlases copy] forKey:atlasName];
    }
}

- (void)purgeAtlasesWithUnitName:(NSString *)unitName
{
    if (unitName)
    {
        [self.textures removeObjectForKey:unitName];
    }
}

#pragma mark - Accessing to atlases

- (NSDictionary<NSString *, NSArray *> *)atlasesWithUnitName:(NSString *)unitName;
{
    NSDictionary<NSString *, NSArray *> *result = nil;
    
    if (unitName)
    {
        result = [self.textures objectForKey:unitName];
    }
    
    return result;
}

@end
