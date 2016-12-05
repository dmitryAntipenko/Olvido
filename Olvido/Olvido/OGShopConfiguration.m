//
//  OGShopConfiguration.m
//  Olvido
//
//  Created by Александр Песоцкий on 12/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGShopConfiguration.h"
#import "OGShopItemConfiguration.h"

NSString *const OGShopConfigurationItemsKey = @"Items";
NSString *const OGShopConfigurationIdentifierKey = @"Id";

NSString *const OGShopConfigurationDefaultShopItemsFileName = @"DefaultShopItems";
NSString *const OGShopConfigurationDefaultShopItemsFileExtension = @"plist";

@interface OGShopConfiguration ()

@property (nonatomic, strong) NSMutableArray<OGShopItemConfiguration *> *mutableShopItemsConfiguration;

@property (nonatomic, strong) NSDictionary *configurationDictionary;

@end

@implementation OGShopConfiguration

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (dictionary)
    {
        self = [self init];
        
        if (self)
        {
            NSString *identifiers = dictionary[OGShopConfigurationIdentifierKey];
            
            if (identifiers)
            {
                _identifier = identifiers;
            }
            
            NSArray *items = dictionary[OGShopConfigurationItemsKey];
            _mutableShopItemsConfiguration = [[NSMutableArray alloc] init];
            
            for (NSString *identifier in items)
            {
                [self loadShopItemWithIdentifier:identifier];
            }
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

- (void)loadShopItemWithIdentifier:(NSString *)identifier
{
    NSDictionary *shopItem = configurationDictionary[identifier];
    
    if (shopItem)
    {
        OGShopItemConfiguration *itemConfiguration = [[OGShopItemConfiguration alloc] initWithDictionary:shopItem];
        [self.mutableShopItemsConfiguration addObject:itemConfiguration];
    }
}


- (NSArray<OGShopItemConfiguration *> *)shopItemsConfiguration
{
    return self.mutableShopItemsConfiguration;
}

- (NSDictionary *)configurationDictionary
{
    if (!_configurationDictionary)
    {
        NSURL *configurationURL = [[NSBundle mainBundle] URLForResource:OGShopConfigurationDefaultShopItemsFileName
                                                          withExtension:OGShopConfigurationDefaultShopItemsFileExtension];
        
        _configurationDictionary = [NSDictionary dictionaryWithContentsOfURL:configurationURL];
    }
    
    return _configurationDictionary;
}

@end
