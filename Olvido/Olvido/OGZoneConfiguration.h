//
//  OGZoneConfiguration.h
//  Olvido
//
//  Created by Алексей Подолян on 12/2/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OGZoneConfiguration : NSObject

@property (nonatomic, strong, readonly) NSString *zoneNodeName;
@property (nonatomic, strong, readonly) Class zoneClass;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
