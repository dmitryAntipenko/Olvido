//
//  OGGameSceneConfiguration.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameSceneConfiguration.h"
#import "OGEnemyConfiguration.h"
#import "OGPlayerConfiguration.h"

NSString *const kOGGameSceneConfigurationEnemiesKey = @"Enemies";
NSString *const kOGGameSceneConfigurationPlayerKey = @"Player";
NSString *const kOGGameSceneConfigurationStartRoomKey = @"StartRoom";

@interface OGGameSceneConfiguration ()

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

- (void)loadConfigurationWithFileName:(NSString *)fileName
{
    NSURL *configurationURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"plist"];
    
    NSDictionary *configurationDictionary = [NSDictionary dictionaryWithContentsOfURL:configurationURL];
    
    self.startRoom = configurationDictionary[kOGGameSceneConfigurationStartRoomKey];
    
    NSDictionary *playerConfigurationDictionary = configurationDictionary[kOGGameSceneConfigurationPlayerKey];
    
    OGPlayerConfiguration *playerConfiguration = [[OGPlayerConfiguration alloc] initWithDictionary:playerConfigurationDictionary];
    self.playerConfiguration = playerConfiguration;
    
    NSArray *enemiesConfigurationDictionary = configurationDictionary[kOGGameSceneConfigurationEnemiesKey];
    
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
