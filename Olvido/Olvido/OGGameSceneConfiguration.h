//
//  OGGameSceneConfiguration.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OGPlayerConfiguration;
@class OGEnemyConfiguration;
@class OGZoneConfiguration;

@interface OGGameSceneConfiguration : NSObject

@property (nonatomic, copy, readonly) NSString *backgroundMusic;
@property (nonatomic, copy, readonly) NSString *startRoom;
@property (nonatomic, strong, readonly) OGPlayerConfiguration *playerConfiguration;
@property (nonatomic, strong, readonly) NSArray<OGEnemyConfiguration *> *enemiesConfiguration;
@property (nonatomic, strong, readonly) NSArray<OGZoneConfiguration *> *zoneConfigurations;

+ (instancetype)gameSceneConfigurationWithFileName:(NSString *)fileName;

@end
