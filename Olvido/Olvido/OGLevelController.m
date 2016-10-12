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

NSUInteger const kOGLevelControllerLevelChangeInterval = 10;

NSString *const kOGLevelControllerLevelNameFormat = @"Level%2@";
NSString *const kOGLevelControllerLevelExtension = @"plist";

NSString *const kOGLevelControllerColorsKey = @"Colors";
NSString *const kOGLevelControllerObstaclesKey = @"Obstacles";
NSString *const kOGLevelControllerEnemyCountKey = @"Enemy Count";
NSString *const kOGLevelControllerBackgroundColorKey = @"Background Color";
NSString *const kOGLevelControllerAccentColorKey = @"Accent Color";
NSString *const kOGLevelControllerPlayerColorKey = @"Player Color";
NSString *const kOGLevelControllerEnemyColorKey = @"Enemy Color";

NSString *const kOGLevelControllerOriginKey = @"Origin";
NSString *const kOGLevelControllerOriginXKey = @"X";
NSString *const kOGLevelControllerOriginYKey = @"Y";
NSString *const kOGLevelControllerPointsKey = @"Points";
NSString *const kOGLevelControllerPointXKey = @"PointX";
NSString *const kOGLevelControllerPointYKey = @"PointY";
NSString *const kOGLevelControllerObstacleColorKey = @"Color";

@interface OGLevelController ()

@property (nonatomic, assign) BOOL shouldAddBonus;

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
        
            NSArray *pathPointsDictionaries = obstacleDictionary[kOGLevelControllerPointsKey];
        
            CGMutablePathRef obstaclePath = CGPathCreateMutable();
            
            for (NSDictionary *pointDictionary in pathPointsDictionaries)
            {
                CGFloat x = ((NSNumber *)pointDictionary[kOGLevelControllerPointXKey]).floatValue;
                CGFloat y = ((NSNumber *)pointDictionary[kOGLevelControllerPointYKey]).floatValue;
                CGPathAddLineToPoint(obstaclePath, NULL, x, y);
            }
            
            SKColor *obstacleColor = [SKColor colorWithString:obstacleDictionary[kOGLevelControllerObstacleColorKey]];

            OGObstacleNode *obstacle = [OGObstacleNode obstacleNodeWithColor:obstacleColor path:obstaclePath];
            obstacle.position = origin;
            [level addObstacle:obstacle];
            
            CGPathRelease(obstaclePath);
        }
        
        [self.levels setObject:level forKey:number];
        self.currentLevel = level;
        
        [level release];
    }
    else
    {
        self.currentLevel = [self.levels objectForKey:number];
    }
    
    if (rand() % number.integerValue == 0)
    {
        self.shouldAddBonus = YES;
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
    
    if (self.shouldAddBonus)
    {
        [self.gameScene addRandomBonus];
        self.shouldAddBonus = NO;
    }
}

- (void)dealloc
{
    [_levels release];
    
    [super dealloc];
}

@end
