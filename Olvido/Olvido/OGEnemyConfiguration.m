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
            
            _physicsBodyRadius = [dictionary[OGEnemyConfigurationPhysicsBodyRadiusKey] floatValue];
            _enemyClass = NSClassFromString(dictionary[OGEnemyConfigurationConfigurationEnemyTypeKey]);
            
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
