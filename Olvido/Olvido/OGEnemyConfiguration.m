//
//  OGEnemyConfiguration.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyConfiguration.h"
#import "OGTextureConfiguration.h"

NSString *const OGEnemyConfigurationInitialPointKey = @"InitialPoint";
NSString *const OGEnemyConfigurationInitialVectorKey = @"InitialVector";
NSString *const OGEnemyConfigurationInitialVectorDXKey = @"dx";
NSString *const OGEnemyConfigurationInitialVectorDYKey = @"dy";
NSString *const OGEnemyConfigurationPhysicsBodyRadiusKey = @"PhysicsBodyRadius";
NSString *const OGEnemyConfigurationConfigurationEnemyTypeKey = @"Type";
NSString *const OGEnemyConfigurationUnitNameKey = @"UnitName";
NSString *const OGEnemyConfigurationMaxHealthKey = @"MaxHealth";
NSString *const OGEnemyConfigurationCurrentHealthKey = @"CurrentHealth";

NSString *const OGEnemyConfigurationDefaultUnitName = @"Enemy";
NSString *const OGEnemyConfigurationDefaultEnemyType = @"OGZombie";

CGFloat const OGEnemyConfigurationDefaultPhysicsBodyRadius = 30.0;

NSInteger const OGEnemyConfigurationDefaultMaxHealth = 10;
NSInteger const OGEnemyConfigurationDefaultCurrentHealth = 10;

@implementation OGEnemyConfiguration

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (dictionary)
    {
        self = [super initWithDictionary:dictionary];
        
        if (self)
        {
            _physicsBodyRadius = OGEnemyConfigurationDefaultPhysicsBodyRadius;
            _maxHealth = OGEnemyConfigurationDefaultMaxHealth;
            _currentHealth = OGEnemyConfigurationDefaultCurrentHealth;

            if (dictionary[OGEnemyConfigurationPhysicsBodyRadiusKey])
            {
                _physicsBodyRadius = [dictionary[OGEnemyConfigurationPhysicsBodyRadiusKey] floatValue];
            }
            
            if (dictionary[OGEnemyConfigurationMaxHealthKey])
            {
                _maxHealth = [dictionary[OGEnemyConfigurationMaxHealthKey] integerValue];
            }
                
            if (dictionary[OGEnemyConfigurationCurrentHealthKey])
            {
                _currentHealth = [dictionary[OGEnemyConfigurationCurrentHealthKey] integerValue];
            }
            
            NSString *enemyType = dictionary[OGEnemyConfigurationConfigurationEnemyTypeKey];
            
            if (enemyType)
            {
                _enemyClass = NSClassFromString(enemyType);
            }
            else
            {
                _enemyClass = NSClassFromString(OGEnemyConfigurationDefaultEnemyType);
            }
            
            if (!self.unitName)
            {
                self.unitName = OGEnemyConfigurationDefaultUnitName;
            }
        }
    }
    
    return self;
}

@end
