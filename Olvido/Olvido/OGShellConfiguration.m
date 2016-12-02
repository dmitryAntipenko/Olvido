//
//  OGShellConfiguration.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 12/2/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGShellConfiguration.h"

NSString *const OGShellConfigurationDamageKey = @"Damage";
NSString *const OGShellConfigurationSpeedKey = @"Speed";
NSString *const OGShellConfigurationTextureNameKey = @"Texture";

@interface OGShellConfiguration ()

@property (nonatomic, assign) NSInteger damage;
@property (nonatomic, assign) NSInteger speed;
@property (nonatomic, copy) NSString *textureName;

@end

@implementation OGShellConfiguration

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self)
    {
        _damage = [dictionary[OGShellConfigurationDamageKey] integerValue];
        _speed = [dictionary[OGShellConfigurationSpeedKey] integerValue];
        _textureName = dictionary[OGShellConfigurationTextureNameKey];
    }
    
    return self;
}

@end
