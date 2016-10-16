//
//  OGScenesController.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGScenesController.h"
#import "OGGameSceneDelegate.h"
#import "OGGameScene.h"
#import "OGPortal.h"

NSString *const kOGSceneControllerLevelMapName = @"LevelsMap";
NSString *const kOGSceneControllerLevelMapExtension = @"plist";

NSString *const kOGSceneControllerPortalsKey = @"Portals";
NSString *const kOGSceneControllerNextLevelIndexKey = @"Next Level Index";
NSString *const kOGSceneControllerLocationKey = @"Location";
NSString *const kOGSceneControllerClassNameKey = @"Class Name";

NSNumber *const kOGSceneControllerInitialLevelIndex = 0;

CGFloat const kOGSceneControllerTransitionDuration = 1.0;

@interface OGScenesController () <OGGameSceneDelegate>

@property (nonatomic, retain) OGGameScene *currentScene;
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
    NSArray *gates = self.levelMap[currentLevelId][kOGSceneControllerPortalsKey];
    
    NSNumber *nextLevelId = gates[0][kOGSceneControllerNextLevelIndexKey];
    [self loadLevelWithIdentifier:nextLevelId];
}

- (void)loadLevelWithIdentifier:(NSNumber *)identifier
{
    NSString *className = self.levelMap[identifier.integerValue][kOGSceneControllerClassNameKey];
    NSArray *portals = self.levelMap[identifier.integerValue][kOGSceneControllerPortalsKey];
    
    Class class = NSClassFromString(className);
    OGGameScene *scene = [[class alloc] init];
    
    scene.identifier = identifier;
    scene.sceneDelegate = self;
    [scene createSceneContents];
    
    self.currentScene = scene;
    [scene release];

    for (NSDictionary *portalDictionary in portals)
    {
        OGPortal *portal = [OGPortal portalWithLocation:portalDictionary[kOGSceneControllerLocationKey]];
        [scene addPortal:portal];
    }
    
    SKTransition *transition = [SKTransition moveInWithDirection:SKTransitionDirectionDown
                                                        duration:kOGSceneControllerTransitionDuration];
    
    [self.view presentScene:self.currentScene transition:transition];
}

- (void)dealloc
{
    [_currentScene release];
    [_levelMap release];
    [_currentScene release];
    
    [super dealloc];
}

@end
