//
//  OGPlayerConfiguration.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerConfiguration.h"
#import "OGTextureConfiguration.h"

NSString *const kOGPlayerConfigurationPhysicsBodyRadiusKey = @"PhysicsBodyRadius";
NSString *const kOGPlayerConfigurationMessageShowDistanceKey = @"MessageShowDistance";
NSString *const kOGPlayerConfigurationMaxHealthKey = @"MaxHealth";
NSString *const kOGPlayerConfigurationCurrentHealthKey = @"CurrentHealth";
NSString *const kOGPlayerConfigurationTexturesKey = @"Textures";

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
            
            _physicsBodyRadius = [dictionary[kOGPlayerConfigurationPhysicsBodyRadiusKey] floatValue];
            _messageShowDistance = [dictionary[kOGPlayerConfigurationMessageShowDistanceKey] floatValue];
            _maxHealth = [dictionary[kOGPlayerConfigurationMaxHealthKey] floatValue];
            _currentHealth = [dictionary[kOGPlayerConfigurationCurrentHealthKey] floatValue];
            
            for (NSDictionary *textureDictionary in dictionary[kOGPlayerConfigurationTexturesKey])
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
