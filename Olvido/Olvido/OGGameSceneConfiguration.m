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

NSString *const OGGameSceneConfigurationEnemiesKey = @"Enemies";
NSString *const OGGameSceneConfigurationPlayerKey = @"Player";
NSString *const OGGameSceneConfigurationStartRoomKey = @"StartRoom";
NSString *const OGGameSceneConfigurationFileExtension = @"plist";
NSString *const OGGameSceneConfigurationBackgroundMusicKey = @"BackgroundMusic";

@interface OGGameSceneConfiguration ()

@property (nonatomic, copy, readwrite) NSString *backgroundMusic;
@property (nonatomic, copy, readwrite) NSString *startRoom;
@property (nonatomic, strong, readwrite) OGPlayerConfiguration *playerConfiguration;
@property (nonatomic, strong, readwrite) NSMutableArray<OGEnemyConfiguration *> *mutableEnemiesConfiguration;

@end

@implementation OGGameSceneConfiguration

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _mutableEnemiesConfiguration = [[NSMutableArray alloc] init];
    }
    
    return self;
}

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
}

- (NSArray<OGEnemyConfiguration *> *)enemiesConfiguration
{
    return self.mutableEnemiesConfiguration;
}

@end
