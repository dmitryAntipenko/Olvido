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
NSString *const OGEnemyConfigurationTexturesKey = @"Textures";
NSString *const OGEnemyConfigurationUnitNameKey = @"UnitName";
NSString *const OGEnemyConfigurationMaxHealthKey = @"MaxHealth";
NSString *const OGEnemyConfigurationCurrentHealthKey = @"CurrentHealth";

NSString *const OGEnemyConfigurationDefaultUnitName = @"Enemy";
NSString *const OGEnemyConfigurationDefaultEnemyType = @"OGZombie";

CGFloat const OGEnemyConfigurationDefaultPhysicsBodyRadius = 30.0;

NSInteger const OGEnemyConfigurationDefaultMaxHealth = 30;
NSInteger const OGEnemyConfigurationDefaultCurrentHealth = 30;

@interface OGEnemyConfiguration ()

@property (nonatomic, strong, readwrite) NSMutableArray<OGTextureConfiguration *> *mutableEnemyTextures;

@end

@implementation OGEnemyConfiguration

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (dictionary)
    {
        self = [super init];
        
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
            
            NSString *unitName = dictionary[OGEnemyConfigurationUnitNameKey];
            
            if (unitName)
            {
                _unitName = unitName;
            }
            else
            {
                _unitName = OGEnemyConfigurationDefaultUnitName;
            }
            
            _mutableEnemyTextures = [NSMutableArray array];
            
            for (NSDictionary *textureDictionary in dictionary[OGEnemyConfigurationTexturesKey])
            {
                OGTextureConfiguration *textureConfiguration = [[OGTextureConfiguration alloc] initWithDictionary:textureDictionary];
                [_mutableEnemyTextures addObject:textureConfiguration];
            }
        }
    }
    
    return self;
}

- (NSArray *)enemyTextures
{
    return self.mutableEnemyTextures;
}

@end
