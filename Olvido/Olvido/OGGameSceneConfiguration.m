//
//  OGGameSceneConfiguration.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameSceneConfiguration.h"
#import "OGEnemyConfiguration.h"

NSString *const kOGGameSceneConfigurationEnemiesKey = @"Enemies";

@interface OGGameSceneConfiguration ()

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
