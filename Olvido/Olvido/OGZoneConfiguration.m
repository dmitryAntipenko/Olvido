//
//  OGZoneConfiguration.m
//  Olvido
//
//  Created by Алексей Подолян on 12/2/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGZoneConfiguration.h"

NSString *const OGZoneConfigurationZoneNodeNameKey = @"ZoneNodeName";
NSString *const OGZoneConfigurationZoneClassNameKey = @"ZoneType";

@implementation OGZoneConfiguration

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (dictionary)
    {
        self = [super initWithDictionary:dictionary];
        
        if (self)
        {
            NSString *nodeName = [dictionary objectForKey:OGZoneConfigurationZoneNodeNameKey];
            NSString *zoneType = [dictionary objectForKey:OGZoneConfigurationZoneClassNameKey];
            
            if (nodeName && zoneType)
            {
                _zoneNodeName = [nodeName copy];
                _zoneType = [zoneType copy];
            }
            else
            {
                self = nil;
            }
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

@end
