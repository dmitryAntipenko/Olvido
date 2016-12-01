//
//  OGAudioConfiguration.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 12/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGAudioConfiguration.h"

NSString *const OGAudioConfigurationAudioNameKey = @"AudioName";
NSString *const OGAudioConfigurationKey = @"Key";
NSString *const OGAudioConfigurationRepeatForeverKey = @"RepeatForever";

BOOL const OGAudioConfigurationRepeatForeverDefault = NO;

@interface OGAudioConfiguration ()

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *audioName;
@property (nonatomic, assign) BOOL repeatForever;

@end

@implementation OGAudioConfiguration

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self)
    {
        _repeatForever = OGAudioConfigurationRepeatForeverDefault;
        
        NSString *audioName = dictionary[OGAudioConfigurationAudioNameKey];
        
        if (audioName)
        {
            _audioName = dictionary[OGAudioConfigurationAudioNameKey];
        }
        
        NSString *key = dictionary[OGAudioConfigurationKey];
        
        if (key)
        {
            _key = dictionary[OGAudioConfigurationKey];
        }
        
        NSString *repeatForever = dictionary[OGAudioConfigurationRepeatForeverKey];
        
        if (repeatForever)
        {
            _repeatForever = [dictionary[OGAudioConfigurationRepeatForeverKey] boolValue];
        }
        
    }
    
    return self;
}

@end
