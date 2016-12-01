//
//  OGGameSceneConfiguration.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameSceneConfiguration.h"
#import "OGPlayerConfiguration.h"
#import "OGEnemyConfiguration.h"
#import "OGAudioConfiguration.h"
#import "OGWeaponConfiguration.h"
#import "OGEntityConfiguration.h"
#import "OGDoorConfiguration.h"

NSString *const OGGameSceneConfigurationEnemiesKey = @"Enemies";
NSString *const OGGameSceneConfigurationPlayerKey = @"Player";
NSString *const OGGameSceneConfigurationWeaponKey = @"Weapon";
NSString *const OGGameSceneConfigurationDoorsKey = @"Doors";
NSString *const OGGameSceneConfigurationSceneItemsKey = @"SceneItems";

NSString *const OGGameSceneConfigurationStartRoomKey = @"StartRoom";
NSString *const OGGameSceneConfigurationBackgroundMusicKey = @"BackgroundMusic";

NSString *const OGGameSceneConfigurationFileExtension = @"plist";

@interface OGGameSceneConfiguration ()

@property (nonatomic, copy, readwrite) NSString *backgroundMusic;
@property (nonatomic, copy, readwrite) NSString *startRoom;
@property (nonatomic, strong, readwrite) OGPlayerConfiguration *playerConfiguration;
@property (nonatomic, strong, readwrite) NSMutableArray<OGEnemyConfiguration *> *mutableEnemiesConfiguration;
@property (nonatomic, strong, readwrite) NSMutableArray<OGWeaponConfiguration *> *mutableWeaponConfigurations;
@property (nonatomic, strong, readwrite) NSMutableArray<OGDoorConfiguration *> *mutableDoorConfigurations;

@property (nonatomic, strong) NSMutableArray<OGEntityConfiguration *> *searchingArray;

@end

@implementation OGGameSceneConfiguration

#pragma mark - Initializing

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _mutableEnemiesConfiguration = [NSMutableArray array];
        _mutableWeaponConfigurations = [NSMutableArray array];
        _mutableDoorConfigurations = [NSMutableArray array];
        _searchingArray = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark -

+ (instancetype)gameSceneConfigurationWithFileName:(NSString *)fileName;
{
    OGGameSceneConfiguration *configuration = nil;
    
    configuration = [[self alloc] init];
    
    if (configuration && fileName)
    {
        [configuration loadConfigurationWithFileName:fileName];
    }
    
    return configuration;
}

- (void)loadConfigurationWithFileName:(NSString *)fileName
{
    NSURL *configurationURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:OGGameSceneConfigurationFileExtension];
    
    NSDictionary *configurationDictionary = [NSDictionary dictionaryWithContentsOfURL:configurationURL];
    
    self.startRoom = configurationDictionary[OGGameSceneConfigurationStartRoomKey];
    self.backgroundMusic = configurationDictionary[OGGameSceneConfigurationBackgroundMusicKey];
    
    NSDictionary *playerConfigurationDictionary = configurationDictionary[OGGameSceneConfigurationPlayerKey];
    
    OGPlayerConfiguration *playerConfiguration = [[OGPlayerConfiguration alloc] initWithDictionary:playerConfigurationDictionary];
    self.playerConfiguration = playerConfiguration;
    
    NSArray *enemiesConfigurationDictionary = configurationDictionary[OGGameSceneConfigurationEnemiesKey];
    
    for (NSDictionary *enemyDictionary in enemiesConfigurationDictionary)
    {
        OGEnemyConfiguration *enemyConfiguration = [[OGEnemyConfiguration alloc] initWithDictionary:enemyDictionary];
        [self.mutableEnemiesConfiguration addObject:enemyConfiguration];
    }
    
    NSArray *weaponConfigurationsDictionary = configurationDictionary[OGGameSceneConfigurationWeaponKey];
    
    for (NSDictionary *weaponDictionary in weaponConfigurationsDictionary)
    {
        OGWeaponConfiguration *weaponConfiguration = [[OGWeaponConfiguration alloc] initWithDictionary:weaponDictionary];
        [self.mutableWeaponConfigurations addObject:weaponConfiguration];
    }
    
    NSArray *doorConfigurationsDictionary = configurationDictionary[OGGameSceneConfigurationDoorsKey];
    
    for (NSDictionary *doorDictionary in doorConfigurationsDictionary)
    {
        OGDoorConfiguration *doorConfiguration = [[OGDoorConfiguration alloc] initWithDictionary:doorDictionary];
        [self.mutableDoorConfigurations addObject:doorConfiguration];
    }
    
    [self.searchingArray addObject:self.playerConfiguration];
    [self.searchingArray addObjectsFromArray:self.mutableWeaponConfigurations];
    [self.searchingArray addObjectsFromArray:self.mutableEnemiesConfiguration];
    [self.searchingArray addObjectsFromArray:self.mutableDoorConfigurations];
}

- (OGEntityConfiguration *)findConfigurationWithUnitName:(NSString *)unitName
{
    OGEntityConfiguration *result = nil;
    
    for (OGEntityConfiguration *configuration in self.searchingArray)
    {
        if ([configuration.unitName isEqualToString:unitName])
        {
            result = configuration;
            break;
        }
    }
    
    return result;
}

#pragma mark - Getters

- (NSArray<OGEnemyConfiguration *> *)enemiesConfiguration
{
    return [self.mutableEnemiesConfiguration copy];
}

- (NSArray<OGWeaponConfiguration *> *)weaponConfigurations
{
    return [self.mutableWeaponConfigurations copy];
}

- (NSArray<OGDoorConfiguration *> *)doorConfigurations
{
    return [self.mutableDoorConfigurations copy];
}

@end
