//
//  OGEnemyConfiguration.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyConfiguration.h"
#import "OGTextureConfiguration.h"

NSString *const kOGEnemyConfigurationInitialPointKey = @"InitialPoint";
NSString *const kOGEnemyConfigurationInitialVectorKey = @"InitialVector";
NSString *const kOGEnemyConfigurationInitialVectorDXKey = @"dx";
NSString *const kOGEnemyConfigurationInitialVectorDYKey = @"dy";
NSString *const kOGEnemyConfigurationPhysicsBodyRadiusKey = @"PhysicsBodyRadius";
NSString *const kOGEnemyConfigurationConfigurationEnemyTypeKey = @"Type";
NSString *const kOGEnemyConfigurationTexturesKey = @"Textures";

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
            _mutableEnemyTextures = [NSMutableArray array];
            
            _physicsBodyRadius = [dictionary[kOGEnemyConfigurationPhysicsBodyRadiusKey] floatValue];
            _enemyClass = NSClassFromString(dictionary[kOGEnemyConfigurationConfigurationEnemyTypeKey]);
            
            for (NSDictionary *textureDictionary in dictionary[kOGEnemyConfigurationTexturesKey])
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
