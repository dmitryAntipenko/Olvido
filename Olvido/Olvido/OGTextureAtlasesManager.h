//
//  OGTextureManager.h
//  Olvido
//
//  Created by Алексей Подолян on 11/23/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OGTextureAtlasesManager : NSObject

+ (instancetype)sharedInstance;

#pragma mark - Atlases managment

- (void)addAtlasWithUnitName:(NSString *)unitName atlasKey:(NSString *)atlasKey atlas:(SKTextureAtlas *)atlas;

- (void)addOrReplaceAtlasWithUnitName:(NSString *)unitName atlasKey:(NSString *)atlasKey atlas:(SKTextureAtlas *)atlas;

- (void)purgeAtlasesWithUnitName:(NSString *)unitName;

- (void)purgeAllTextures;

- (BOOL)containsAtlasWithKey:(NSString *)atlasKey unitName:(NSString *)unitName;

#pragma mark - Access to atlases

- (NSDictionary<NSString *, SKTextureAtlas *> *)atlasesWithUnitName:(NSString *)unitName;

- (SKTextureAtlas *)atlasWithUnitName:(NSString *)unitName atlasKey:(NSString *)atlasKey;

@end
