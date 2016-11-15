//
//  OGPlayerConfiguration.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerConfiguration.h"

NSString *const kOGPlayerConfigurationPhysicsBodyRadiusKey = @"PhysicsBodyRadius";
NSString *const kOGPlayerConfigurationMessageShowDistanceKey = @"MessageShowDistance";
NSString *const kOGPlayerConfigurationMaxHealthKey = @"MaxHealth";
NSString *const kOGPlayerConfigurationCurrentHealthKey = @"CurrentHealth";

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
        self = [super init];
        
        if (self)
        {
            _physicsBodyRadius = [dictionary[kOGPlayerConfigurationPhysicsBodyRadiusKey] floatValue];
            _messageShowDistance = [dictionary[kOGPlayerConfigurationMessageShowDistanceKey] floatValue];
            _maxHealth = [dictionary[kOGPlayerConfigurationMaxHealthKey] floatValue];
            _currentHealth = [dictionary[kOGPlayerConfigurationCurrentHealthKey] floatValue];
        }
    }
    
    return self;
}

@end
