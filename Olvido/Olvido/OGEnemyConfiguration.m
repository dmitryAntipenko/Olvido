//
//  OGEnemyConfiguration.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyConfiguration.h"

NSString *const kOGEnemyConfigurationInitialPointKey = @"InitialPoint";
NSString *const kOGEnemyConfigurationInitialVectorKey = @"InitialVector";
NSString *const kOGEnemyConfigurationInitialVectorDXKey = @"dx";
NSString *const kOGEnemyConfigurationInitialVectorDYKey = @"dy";
NSString *const kOGEnemyConfigurationPhysicsBodyRadiusKey = @"PhysicsBodyRadius";
NSString *const kOGEnemyConfigurationConfigurationEnemyTypeKey = @"Type";

@interface OGEnemyConfiguration ()

@property (nonatomic, copy, readwrite) NSString *initialPointName;
@property (nonatomic, assign, readwrite) CGVector initialVector;

@end

@implementation OGEnemyConfiguration

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (dictionary)
    {
        self = [super init];
        
        if (self)
        {
            _initialPointName = dictionary[kOGEnemyConfigurationInitialPointKey];
            
            CGFloat dx = [dictionary[kOGEnemyConfigurationInitialVectorKey][kOGEnemyConfigurationInitialVectorDXKey] floatValue];
            CGFloat dy = [dictionary[kOGEnemyConfigurationInitialVectorKey][kOGEnemyConfigurationInitialVectorDYKey] floatValue];
            _initialVector = CGVectorMake(dx, dy);
            
            _physicsBodyRadius = [dictionary[kOGEnemyConfigurationPhysicsBodyRadiusKey] floatValue];
            
            _enemyClass = NSClassFromString(dictionary[kOGEnemyConfigurationConfigurationEnemyTypeKey]);
        }
    }
    
    return self;
}

@end
