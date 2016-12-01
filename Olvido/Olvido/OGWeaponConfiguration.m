//
//  OGWeaponConfiguration.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 12/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGWeaponConfiguration.h"

NSString *const OGWeaponConfigurationAttackSpeedKey = @"AttackSpeed";
NSString *const OGWeaponConfigurationReloadSpeedKey = @"ReloadSpeed";
NSString *const OGWeaponConfigurationChargeKey = @"Charge";
NSString *const OGWeaponConfigurationMaxChargeKey = @"MaxCharge";

@interface OGWeaponConfiguration ()

@property (nonatomic, assign, readwrite) CGFloat attackSpeed;
@property (nonatomic, assign, readwrite) CGFloat reloadSpeed;
@property (nonatomic, assign, readwrite) NSUInteger charge;
@property (nonatomic, assign, readwrite) NSUInteger maxCharge;

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
        
        if (!dictionary[OGWeaponConfigurationMaxChargeKey])
        {
            _maxCharge = _charge;
        }
        else
        {
            _maxCharge = [dictionary[OGWeaponConfigurationMaxChargeKey] integerValue];
        }
    }
    
    return self;
}

@end
