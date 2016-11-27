//
//  OGTextureConfiguration.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/25/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OGTextureConfiguration : NSObject

@property (nonatomic, strong, readonly) NSString *pairTextureName;
@property (nonatomic, strong, readonly) NSString *textureName;
@property (nonatomic, assign, readonly) CGFloat timePerFrame;
@property (nonatomic, assign, readonly) BOOL repeatForever;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
