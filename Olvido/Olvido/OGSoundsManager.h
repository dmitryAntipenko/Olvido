//
//  OGSoundsmanager.h
//  Olvido
//
//  Created by Алексей Подолян on 11/24/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OGSoundsManager : NSObject

+ (instancetype)sharedInstance;

#pragma mark - Atlases managment

- (void)addSoundWithUnitName:(NSString *)unitName asoundKey:(NSString *)soundKey f:(NSString *)fileName;

//- (void)purgeAtlasesWithUnitName:(NSString *)unitName;
//
//- (void)purgeAllTextures;
//
//- (BOOL)containsAtlasWithKey:(NSString *)atlasKey unitName:(NSString *)unitName;
//
//#pragma mark - Access to atlases
//
//- (NSDictionary<NSString *, SKTextureAtlas *> *)atlasesWithUnitName:(NSString *)unitName;
//
//- (SKTextureAtlas *)atlasWithUnitName:(NSString *)unitName atlasKey:(NSString *)atlasKey;

@end
