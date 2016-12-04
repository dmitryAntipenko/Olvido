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
@class OGWeaponConfiguration;
@class OGDoorConfiguration;
@class OGEntityConfiguration;
@class OGZoneConfiguration;

@interface OGGameSceneConfiguration : NSObject

@property (nonatomic, copy, readonly) NSString *backgroundMusic;
@property (nonatomic, copy, readonly) NSString *startRoom;

@property (nonatomic, strong, readonly) OGPlayerConfiguration *playerConfiguration;
@property (nonatomic, strong, readonly) NSArray<OGEnemyConfiguration *> *enemyConfigurations;
@property (nonatomic, strong, readonly) NSArray<OGWeaponConfiguration *> *weaponConfigurations;
@property (nonatomic, strong, readonly) NSArray<OGDoorConfiguration *> *doorConfigurations;
@property (nonatomic, strong, readonly) NSArray<OGZoneConfiguration *> *zoneConfigurations;

+ (instancetype)gameSceneConfigurationWithFileName:(NSString *)fileName;

- (OGEntityConfiguration *)findConfigurationWithUnitName:(NSString *)unitName;

@end
