//
//  OGWeaponConfiguration.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 12/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGWeaponConfiguration.h"
#import "OGShellConfiguration.h"

NSString *const OGWeaponConfigurationAttackSpeedKey = @"AttackSpeed";
NSString *const OGWeaponConfigurationReloadSpeedKey = @"ReloadSpeed";
NSString *const OGWeaponConfigurationChargeKey = @"Charge";
NSString *const OGWeaponConfigurationMaxChargeKey = @"MaxCharge";
NSString *const OGWeaponConfigurationSpreadKey = @"Spread";
NSString *const OGWeaponConfigurationIdentifierKey = @"Identifier";
NSString *const OGWeaponConfigurationShellKey = @"Shell";

@interface OGWeaponConfiguration ()

@property (nonatomic, assign, readwrite) CGFloat attackSpeed;
@property (nonatomic, assign, readwrite) CGFloat reloadSpeed;
@property (nonatomic, assign, readwrite) NSUInteger charge;
@property (nonatomic, assign, readwrite) NSUInteger maxCharge;
@property (nonatomic, assign, readwrite) CGFloat spread;
@property (nonatomic, copy, readwrite) NSString *inventoryIdentifier;
@property (nonatomic, strong, readwrite) OGShellConfiguration *shellConfiguration;

@end

@implementation OGWeaponConfiguration

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self)
    {
        _attackSpeed = [dictionary[OGWeaponConfigurationAttackSpeedKey] floatValue];
        _reloadSpeed = [dictionary[OGWeaponConfigurationReloadSpeedKey] floatValue];
        _charge = [dictionary[OGWeaponConfigurationChargeKey] integerValue];
        _spread = [dictionary[OGWeaponConfigurationSpreadKey] floatValue];
        
        if (!dictionary[OGWeaponConfigurationMaxChargeKey])
        {
            _maxCharge = _charge;
        }
        else
        {
            _maxCharge = [dictionary[OGWeaponConfigurationMaxChargeKey] integerValue];
        }
        
        NSString *identifier = dictionary[OGWeaponConfigurationIdentifierKey];
        
        if (identifier)
        {
            _inventoryIdentifier = identifier;
        }
        
        NSDictionary *shellDictionary = dictionary[OGWeaponConfigurationShellKey];
        _shellConfiguration = [[OGShellConfiguration alloc] initWithDictionary:shellDictionary];
    }
    
    return self;
}

@end
