//
//  OGShopConfigurations.m
//  Olvido
//
//  Created by Александр Песоцкий on 12/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGShopConfiguration.h"

NSString *const OGShopConfigurationTextureNameKey = @"TextureName";
NSString *const OGShopConfigurationPriceKey = @"Price";
NSString *const OGShopConfigurationRepresentedEntityClassNameKey = @"RepresentedEntityClassName";
NSString *const OGShopConfigurationRepresentedEntityClassDictionaryKey = @"RepresentedEntityClassDictionary";

@implementation OGShopConfiguration

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (dictionary)
    {
        self = [self init];
        
        if (self)
        {
            
            NSString *textureName = dictionary[OGShopConfigurationTextureNameKey];
            
            if (textureName)
            {
                _texture = [SKTexture textureWithImageNamed:textureName];
            }
            
            if (dictionary[OGShopConfigurationPriceKey])
            {
                _price = [dictionary[OGShopConfigurationPriceKey] floatValue];
            }
            
            NSString *representedEntityClassName = dictionary[OGShopConfigurationRepresentedEntityClassNameKey];
            NSDictionary *representedEntityClassDictianary = dictionary[OGShopConfigurationRepresentedEntityClassDictionaryKey];
            
            if (representedEntityClassName && representedEntityClassDictianary)
            {
                Class representedEntityClass = NSClassFromString(representedEntityClassName);
                _entity = [[representedEntityClass alloc] initWithDictionary:representedEntityClassDictianary];
            }
            
            
            
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

@end
