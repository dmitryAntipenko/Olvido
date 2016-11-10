//
//  OGSceneMetadata.h
//  Olvido
//
//  Created by Алексей Подолян on 11/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OGSceneMetadata : NSObject

@property (nonatomic, unsafe_unretained, readonly) NSUInteger  identifier;
@property (nonatomic, unsafe_unretained, readonly) Class sceneClass;
@property (nonatomic, strong, readonly) NSString *fileName;

+ (instancetype)sceneMetaDataWithSceneConfiguration:(NSDictionary *)configuration identifier:(NSUInteger)identifier;

@end
