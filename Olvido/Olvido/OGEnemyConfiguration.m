//
//  OGEnemyConfiguration.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyConfiguration.h"

NSString *const OGEnemyConfigurationInitialPointKey = @"InitialPoint";
NSString *const OGEnemyConfigurationInitialVectorKey = @"InitialVector";
NSString *const OGEnemyConfigurationInitialVectorDXKey = @"dx";
NSString *const OGEnemyConfigurationInitialVectorDYKey = @"dy";
NSString *const OGEnemyConfigurationPhysicsBodyRadiusKey = @"PhysicsBodyRadius";
NSString *const OGEnemyConfigurationConfigurationEnemyTypeKey = @"Type";

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
            _initialPointName = dictionary[OGEnemyConfigurationInitialPointKey];
            
            CGFloat dx = [dictionary[OGEnemyConfigurationInitialVectorKey][OGEnemyConfigurationInitialVectorDXKey] floatValue];
            CGFloat dy = [dictionary[OGEnemyConfigurationInitialVectorKey][OGEnemyConfigurationInitialVectorDYKey] floatValue];
            _initialVector = CGVectorMake(dx, dy);
            
            _physicsBodyRadius = [dictionary[OGEnemyConfigurationPhysicsBodyRadiusKey] floatValue];
            
            _enemyClass = NSClassFromString(dictionary[OGEnemyConfigurationConfigurationEnemyTypeKey]);
        }
    }
    
    return self;
}

@end
