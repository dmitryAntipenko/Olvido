//
//  OGTextureManager.h
//  Olvido
//
//  Created by Алексей Подолян on 11/23/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OGTextureManager : NSObject

#pragma mark - Init

+ (instancetype)textureManager;

#pragma mark - Memory managment

- (void)loadAtlasWithUnitName:(NSString *)unitName atlasName:(NSString *)atlasName;

- (void)purgeAtlasesWithUnitName:(NSString *)unitName;

#pragma mark - Accessing to atlases

- (NSArray<SKTexture *> *)atlasesWithUnitName:(NSString *)unitName;

@end
