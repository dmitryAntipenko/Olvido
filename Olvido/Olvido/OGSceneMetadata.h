//
//  OGSceneMetadata.h
//  Olvido
//
//  Created by Алексей Подолян on 11/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OGResourceLoadable.h"

@interface OGSceneMetadata : NSObject

@property (nonatomic, assign, readonly) NSUInteger  identifier;
@property (nonatomic, assign, readonly) Class sceneClass;
@property (nonatomic, strong, readonly) NSString *fileName;
@property (nonatomic, strong, readonly) NSArray<Class<OGResourceLoadable>> *loadableClasses;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSDictionary<NSString *, NSString *> *> *textureAtlases;

+ (instancetype)sceneMetaDataWithSceneConfiguration:(NSDictionary *)configuration identifier:(NSUInteger)identifier;

@end
