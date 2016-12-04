//
//  OGDoorConfiguration.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 12/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDoorConfiguration.h"

NSString *const OGDoorConfigurationDestinationKey = @"Destination";
NSString *const OGDoorConfigurationSourceKey = @"Source";
NSString *const OGDoorConfigurationLockedKey = @"Locked";
NSString *const OGDoorConfigurationOpenDistanceKey = @"OpenDistance";
NSString *const OGDoorConfigurationKeysKey = @"Keys";

CGFloat const OGDoorConfigurationDefaultOpenDistance = 50.0;

@interface OGDoorConfiguration ()

@property (nonatomic, copy, readwrite) NSString *destination;
@property (nonatomic, copy, readwrite) NSString *source;
@property (nonatomic, assign, readwrite) BOOL locked;
@property (nonatomic, assign, readwrite) CGFloat openDistance;
@property (nonatomic, strong, readwrite) NSMutableArray<NSString *> *mutableKeys;

@end

@implementation OGDoorConfiguration

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self)
    {
        _destination = dictionary[OGDoorConfigurationDestinationKey];
        _source = dictionary[OGDoorConfigurationSourceKey];
        _locked = [dictionary[OGDoorConfigurationLockedKey] boolValue];
        _mutableKeys = dictionary[OGDoorConfigurationKeysKey];
        
        if (dictionary[OGDoorConfigurationOpenDistanceKey])
        {
            _openDistance = [dictionary[OGDoorConfigurationOpenDistanceKey] floatValue];
        }
        else
        {
            _openDistance = OGDoorConfigurationDefaultOpenDistance;
        }
    }
    
    return self;
}

- (BOOL)isLocked
{
    return self.locked;
}

- (NSArray<NSString *> *)keys
{
    return [_mutableKeys copy];
}

@end
