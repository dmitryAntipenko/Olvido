//
//  OGShellConfiguration.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 12/2/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGShellConfiguration.h"
#import "OGColliderType.h"

NSString *const OGShellConfigurationDamageKey = @"Damage";
NSString *const OGShellConfigurationSpeedKey = @"Speed";
NSString *const OGShellConfigurationTextureNameKey = @"Texture";
NSString *const OGShellConfigurationBitMaskKey = @"BitMask";

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
        if (dictionary)
        {
            _damage = [dictionary[OGShellConfigurationDamageKey] integerValue];
            _speed = [dictionary[OGShellConfigurationSpeedKey] integerValue];
            _textureName = dictionary[OGShellConfigurationTextureNameKey];
            
            SEL bitMaskSelector = NSSelectorFromString(dictionary[OGShellConfigurationBitMaskKey]);
            
            if (bitMaskSelector && [OGColliderType respondsToSelector:bitMaskSelector])
            {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                
                _colliderType = [[OGColliderType class] performSelector:bitMaskSelector];
                
                #pragma clang diagnostic pop
            }
            else
            {
                _colliderType = [OGColliderType bullet];
            }
        }
    }
    
    return self;
}

@end
