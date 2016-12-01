//
//  OGEntityConfiguration.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 12/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEntityConfiguration.h"
#import "OGTextureConfiguration.h"
#import "OGAudioConfiguration.h"

NSString *const OGEntityConfigurationTexturesKey = @"Textures";
NSString *const OGEntityConfigurationAudioKey = @"Audio";
NSString *const OGEntityConfigurationUnitNameKey = @"UnitName";

@interface OGEntityConfiguration ()

@property (nonatomic, strong, readwrite) NSMutableArray<OGTextureConfiguration *> *mutableTextures;
@property (nonatomic, strong, readwrite) NSMutableArray<OGAudioConfiguration *> *mutableAudios;

@end

@implementation OGEntityConfiguration

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (dictionary)
    {
        self = [super init];
        
        if (self)
        {
            _mutableTextures = [NSMutableArray array];
            _mutableAudios = [NSMutableArray array];
            
            _unitName = dictionary[OGEntityConfigurationUnitNameKey];
            
            for (NSDictionary *textureDictionary in dictionary[OGEntityConfigurationTexturesKey])
            {
                OGTextureConfiguration *textureConfiguration = [[OGTextureConfiguration alloc] initWithDictionary:textureDictionary];
                [_mutableTextures addObject:textureConfiguration];
            }
            
            for (NSDictionary *audioDictionary in dictionary[OGEntityConfigurationAudioKey])
            {
                OGAudioConfiguration *audioConfiguration = [[OGAudioConfiguration alloc] initWithDictionary:audioDictionary];
                [_mutableAudios addObject:audioConfiguration];
            }
        }
    }
    
    return self;
}

- (NSArray<OGTextureConfiguration *> *)textures
{
    return _mutableTextures;
}

- (NSArray<OGAudioConfiguration *> *)audios
{
    return _mutableAudios;
}

@end
