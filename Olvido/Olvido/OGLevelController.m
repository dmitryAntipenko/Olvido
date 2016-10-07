//
//  OGLevelController.m
//  Olvido
//
//  Created by Алексей Подолян on 10/5/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLevelController.h"
#import "OGLevel.h"
#import "OGTimerNode.h"
#import "SKColor+OGConstantColors.h"
#import "OGLevelChanging.h"
#import "OGObstacleNode.h"
#import "OGConstants.h"

@interface OGLevelController ()

@property (nonatomic, assign) OGLevel *currentLevel;
@property (nonatomic, retain) NSMutableDictionary<NSNumber *, OGLevel *> *levels;

@end

@implementation OGLevelController

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _levels = [[NSMutableDictionary alloc] init];
    }
    else
    {
        [self release];
        self = nil;
    }
    
    return self;
}

- (void)loadLevelWithNumber:(NSNumber *)number
{
    if (![self.levels.allKeys containsObject:number])
    {
        NSString *levelName = [NSString stringWithFormat:kOGLevelControllerLevelNameFormat, number];
        NSString *levelPlist = [[NSBundle mainBundle] pathForResource:levelName ofType:kOGLevelControllerLevelExtension];
        NSDictionary *levelData = [NSDictionary dictionaryWithContentsOfFile:levelPlist];
        
        NSDictionary *levelColors = levelData[kOGLevelControllerColorsKey];
        NSArray<NSDictionary *> *levelObstacles = levelData[kOGLevelControllerObstaclesKey];
        
        OGLevel *level = [[OGLevel alloc] init];
        
        level.identifier = number;
        level.enemyCount = levelData[kOGLevelControllerEnemyCountKey];
        level.backgroundColor = [SKColor colorWithString:levelColors[kOGLevelControllerBackgroundColorKey]];
        level.accentColor = [SKColor colorWithString:levelColors[kOGLevelControllerAccentColorKey]];
        level.playerColor = [SKColor colorWithString:levelColors[kOGLevelControllerPlayerColorKey]];
        level.enemyColor = [SKColor colorWithString:levelColors[kOGLevelControllerEnemyColorKey]];
        
        for (NSDictionary *obstacleDictionary in levelObstacles)
        {
            NSDictionary *originDictionary = obstacleDictionary[kOGLevelControllerOriginKey];
            CGPoint origin = CGPointMake(((NSNumber *) originDictionary[kOGLevelControllerOriginXKey]).floatValue,
                                         ((NSNumber *) originDictionary[kOGLevelControllerOriginYKey]).floatValue);
            
            NSDictionary *sizeDictionary = obstacleDictionary[kOGLevelControllerSizeKey];
            CGSize size = CGSizeMake(((NSNumber *) sizeDictionary[kOGLevelControllerSizeWidthKey]).floatValue,
                                     ((NSNumber *) sizeDictionary[kOGLevelControllerSizeHeightKey]).floatValue);
            
            SKColor *obstacleColor = [SKColor colorWithString:obstacleDictionary[kOGLevelControllerObstacleColorKey]];
            
            OGObstacleNode *obstacle = [OGObstacleNode obstacleWithColor:obstacleColor size:size];
            obstacle.position = origin;
            [level addObstacle:obstacle];
        }
        
        [self.levels setObject:level forKey:number];
        self.currentLevel = level;
        
        [level release];
    }
    else
    {
        self.currentLevel = [self.levels objectForKey:number];
    }
    
    [self updateGameScene];
}

- (void)updateGameScene
{
    [self.gameScene changeBackgroundWithColor:self.currentLevel.backgroundColor];
    [self.gameScene changeAccentWithColor:self.currentLevel.accentColor];
    [self.gameScene changePlayerWithColor:self.currentLevel.playerColor];
    [self.gameScene changeEnemiesWithColor:self.currentLevel.enemyColor enemyCount:self.currentLevel.enemyCount];
    [self.gameScene changeObstacles:self.currentLevel.obstacles];
}

- (void)dealloc
{
    [_levels release];
    
    [super dealloc];
}

@end
