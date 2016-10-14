//
//  OGScenesController.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGScenesController.h"
#import "OGGameSceneDelegate.h"
#import "OGGameSceneProtocol.h"

NSString *const kOGSceneControllerLevelMapName = @"LevelsMap";
NSString *const kOGSceneControllerLevelMapExtension = @"plist";

NSString *const kOGSceneControllerGatesKey = @"Gates";
NSString *const kOGSceneControllerNextLevelIndexKey = @"Next Level Index";
NSString *const kOGSceneControllerClassNameKey = @"Class Name";

NSNumber *const kOGSceneControllerInitialLevelIndex = 0;

CGFloat const kOGSceneControllerTransitionDuration = 1.0;

@interface OGScenesController () <OGGameSceneDelegate>

@property (nonatomic, retain) id <OGGameScene> currentScene;
@property (nonatomic, copy) NSArray *levelMap;

@end

@implementation OGScenesController

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    else
    {
        [self release];
        self = nil;
    }
    
    return self;
}

- (void)loadLevelMap
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:kOGSceneControllerLevelMapName
                                                          ofType:kOGSceneControllerLevelMapExtension];
    
    NSArray *plistData = [NSArray arrayWithContentsOfFile:plistPath];
    
    self.levelMap = plistData;
}

- (void)loadInitialLevel
{
    [self loadLevelWithIdentifier:kOGSceneControllerInitialLevelIndex];
}

- (void)gameSceneDidCallFinish
{
    NSUInteger currentLevelId = [self.currentScene identifier].integerValue;
    NSArray *gates = self.levelMap[currentLevelId][kOGSceneControllerGatesKey];
    
    NSNumber *nextLevelId = gates[0][kOGSceneControllerNextLevelIndexKey];
    [self loadLevelWithIdentifier:nextLevelId];
}

- (void)loadLevelWithIdentifier:(NSNumber *)identifier
{
    NSString *className = self.levelMap[identifier.integerValue][kOGSceneControllerClassNameKey];
    
    Class class = NSClassFromString(className);
    id <OGGameScene> scene = [[class alloc] init];
    
    [scene setIdentifier:identifier];
    [scene setSceneDelegate:self];
    [scene createSceneContents];
    
    self.currentScene = scene;
    
    [scene release];

    // parse gates
    
    SKTransition *transition = [SKTransition moveInWithDirection:SKTransitionDirectionDown duration:kOGSceneControllerTransitionDuration];
    [self.view presentScene:(SKScene *) self.currentScene transition:transition];
}

- (void)dealloc
{
    [_currentScene release];
    [_levelMap release];
    [_currentScene release];
    
    [super dealloc];
}

@end
