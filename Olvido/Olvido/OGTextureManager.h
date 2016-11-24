//
//  OGTextureManager.h
//  Olvido
//
//  Created by Алексей Подолян on 11/23/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OGTextureManager : NSObject

+ (instancetype)sharedInstance;

#pragma mark - Atlases managment

- (void)addAtlasWithUnitName:(NSString *)unitName atlasName:(NSString *)atlasName atlas:(SKTextureAtlas *)atlas;

- (void)purgeAtlasesWithUnitName:(NSString *)unitName;

- (void)purgeAllTextures;

- (BOOL)containsAtlasWithName:(NSString *)atlasName unitName:(NSString *)unitName;

#pragma mark - Access to atlases

- (NSDictionary<NSString *, SKTextureAtlas *> *)atlasesWithUnitName:(NSString *)unitName;

@end
