//
//  OGEntityConfiguration.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 12/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OGTextureConfiguration;
@class OGAudioConfiguration;

@interface OGEntityConfiguration : NSObject

@property (nonatomic, copy) NSString *unitName;

@property (nonatomic, strong, readonly) NSArray<OGTextureConfiguration *> *textures;
@property (nonatomic, strong, readonly) NSArray<OGAudioConfiguration *> *audios;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
