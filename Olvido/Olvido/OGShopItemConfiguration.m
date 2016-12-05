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
NSString *const OGShopConfigurationUnitConfigurationDictionaryKey = @"UnitConfigurationDictionary";
NSString *const OGShopConfigurationUnitConfigurationClasssNameKey = @"UnitConfigurationClasssName";

@implementation OGShopItemConfiguration

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
            
            NSString *unitClassName = dictionary[OGShopConfigurationUnitClassNameKey];
            NSString *unitConfigurationClassName = dictionary[OGShopConfigurationUnitConfigurationClasssNameKey];
            
            NSDictionary *unitConfigurationDictionary = dictionary[OGShopConfigurationUnitConfigurationDictionaryKey];
            
            if (unitClassName || unitConfigurationClassName || unitConfigurationDictionary)
            {
                _unitConfigurationClass = NSClassFromString(unitConfigurationClassName);
                _unitClass = NSClassFromString(unitClassName);
                
                _unitConfiguration = [[_unitConfigurationClass alloc] initWithDictionary:unitConfigurationDictionary];
            }
            
//            NSDictionary *representedItemClassDictianary = dictionary[OGShopConfigurationRepresentedEntityClassDictionaryKey];
//            
//            if (representedItemClassName && representedItemClassDictianary)
//            {
//                _representedItemClass = NSClassFromString(representedItemClassName);
//                _representedItemDictionary = representedItemClassDictianary;
//            }
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

@end
