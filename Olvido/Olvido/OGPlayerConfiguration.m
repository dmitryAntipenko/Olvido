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

@interface OGPlayerConfiguration ()

@property (nonatomic, assign, readwrite) CGFloat physicsBodyRadius;
@property (nonatomic, assign, readwrite) CGFloat messageShowDistance;
@property (nonatomic, assign, readwrite) CGFloat maxHealth;
@property (nonatomic, assign, readwrite) CGFloat currentHealth;

@end

@implementation OGPlayerConfiguration

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (dictionary)
    {
        self = [super initWithDictionary:dictionary];
        
        if (self)
        {
            _physicsBodyRadius = [dictionary[OGPlayerConfigurationPhysicsBodyRadiusKey] floatValue];
            _messageShowDistance = [dictionary[OGPlayerConfigurationMessageShowDistanceKey] floatValue];
            _maxHealth = [dictionary[OGPlayerConfigurationMaxHealthKey] floatValue];
            _currentHealth = [dictionary[OGPlayerConfigurationCurrentHealthKey] floatValue];
        }
    }
    
    return self;
}

@end
