//
//  OGShopConfigurations.m
//  Olvido
//
//  Created by Александр Песоцкий on 12/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGShopItemConfiguration.h"

NSString *const OGShopConfigurationTextureNameKey = @"TextureName";
NSString *const OGShopConfigurationPriceKey = @"Price";
NSString *const OGShopConfigurationUnitClassNameKey = @"UnitClassName";
NSString *const OGShopConfigurationUnitConfigurationDictionaryKey = @"UnitConfiguration";
NSString *const OGShopConfigurationUnitConfigurationClasssNameKey = @"UnitConfigurationClassName";

@implementation OGShopItemConfiguration

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (dictionary)
    {
        self = [super init];
        
        if (self)
        {
            NSString *textureName = dictionary[OGShopConfigurationTextureNameKey];
            
            if (textureName)
            {
                _texture = [SKTexture textureWithImageNamed:textureName];
            }
            
            NSNumber *price = dictionary[OGShopConfigurationPriceKey];
            if (price)
            {
                _price = price;
            }
            
            NSString *unitClassName = dictionary[OGShopConfigurationUnitClassNameKey];
            NSString *unitConfigurationClassName = dictionary[OGShopConfigurationUnitConfigurationClasssNameKey];
            
            NSDictionary *unitConfigurationDictionary = dictionary[OGShopConfigurationUnitConfigurationDictionaryKey];
            
            if (unitClassName && unitConfigurationClassName && unitConfigurationDictionary)
            {
                _unitConfigurationClass = NSClassFromString(unitConfigurationClassName);
                _unitClass = NSClassFromString(unitClassName);
                
                _unitConfiguration = [[_unitConfigurationClass alloc] initWithDictionary:unitConfigurationDictionary];
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
