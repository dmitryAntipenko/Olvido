//
//  OGPlayerConfiguration.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerConfiguration.h"
#import "OGTextureConfiguration.h"

NSString *const OGPlayerConfigurationPhysicsBodyRadiusKey = @"PhysicsBodyRadius";
NSString *const OGPlayerConfigurationMessageShowDistanceKey = @"MessageShowDistance";
NSString *const OGPlayerConfigurationMaxHealthKey = @"MaxHealth";
NSString *const OGPlayerConfigurationCurrentHealthKey = @"CurrentHealth";
NSString *const OGPlayerConfigurationTexturesKey = @"Textures";

@interface OGPlayerConfiguration ()

@property (nonatomic, assign, readwrite) CGFloat physicsBodyRadius;
@property (nonatomic, assign, readwrite) CGFloat messageShowDistance;
@property (nonatomic, assign, readwrite) CGFloat maxHealth;
@property (nonatomic, assign, readwrite) CGFloat currentHealth;
@property (nonatomic, strong, readwrite) NSMutableArray<OGTextureConfiguration *> *mutablePlayerTextures;

@end

@implementation OGPlayerConfiguration

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (dictionary)
    {
        self = [super init];
        
        if (self)
        {
            _mutablePlayerTextures = [NSMutableArray array];
            
            _physicsBodyRadius = [dictionary[OGPlayerConfigurationPhysicsBodyRadiusKey] floatValue];
            _messageShowDistance = [dictionary[OGPlayerConfigurationMessageShowDistanceKey] floatValue];
            _maxHealth = [dictionary[OGPlayerConfigurationMaxHealthKey] floatValue];
            _currentHealth = [dictionary[OGPlayerConfigurationCurrentHealthKey] floatValue];
            
            for (NSDictionary *textureDictionary in dictionary[OGPlayerConfigurationTexturesKey])
            {
                OGTextureConfiguration *textureConfiguration = [[OGTextureConfiguration alloc] initWithDictionary:textureDictionary];
                [_mutablePlayerTextures addObject:textureConfiguration];
            }
        }
    }
    
    return self;
}

- (NSArray<OGTextureConfiguration *> *)playerTextures
{
    return self.mutablePlayerTextures;
}

@end
