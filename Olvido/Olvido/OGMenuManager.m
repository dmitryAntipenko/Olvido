//
//  OGMenuManager.m
//  Olvido
//
//  Created by Алексей Подолян on 11/11/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "OGMenuManager.h"
#import "OGAudioManager.h"
#import "OGSceneManager.h"
#import "OGConstants.h"
#import "OGMenuBaseScene.h"

NSString *const kOGMenuManagerMenuNameKey = @"Name";
NSString *const kOGMenuManagerSceneIdentifierKey = @"SceneIdentifier";
NSString *const kOGMenuManagerMenusMapName = @"MenusMap";
NSString *const kOGMenuManagerMainMenuName = @"OGMainMenuScene";
NSUInteger const kOGMenuManagerMainMenuIdentifier = 0;
NSString *const kOGMenuManagerBackgroundMusic = @"menu_music";

@interface OGMenuManager () <AVAudioPlayerDelegate>

@property (nonatomic, strong, readwrite) OGAudioManager *audioManager;
@property (nonatomic, strong) NSArray<NSDictionary *> *menusMap;
@property (nonatomic, weak) OGMenuBaseScene *currentScene;

@end

@implementation OGMenuManager

+ (instancetype)menuManager
{
    OGMenuManager *menuManager = [[OGMenuManager alloc] init];
    [menuManager loadMenuMap];
    
    return menuManager;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _audioManager = [OGAudioManager audioManager];
    }
    
    return self;
}

- (void)loadMenuMap
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:kOGMenuManagerMenusMapName
                                                          ofType:kOGPropertyFileExtension];
    self.menusMap = [NSArray arrayWithContentsOfFile:plistPath];
}

- (void)loadMainMenu
{
    [self loadMenuWithName:kOGMenuManagerMainMenuName];
}

- (void)loadMenuWithIdentifier:(NSUInteger)menuIdentifier
{
    NSUInteger sceneIdentifer = [self.menusMap[menuIdentifier][kOGMenuManagerSceneIdentifierKey] integerValue];
    
    [self.sceneManager transitionToSceneWithIdentifier:sceneIdentifer
                                     completionHandler:^(OGBaseScene *scene)
     {
         self.currentScene = (OGMenuBaseScene *)scene;
         self.currentScene.menuManager = self;
     }];
}

- (void)loadMenuWithName:(NSString *)menuName
{
    self.currentScene = nil;
    
    __block NSUInteger menuIdentifier = 0;
    
    if (menuName)
    {
        [self.menusMap enumerateObjectsUsingBlock:^(NSDictionary *menuAsDictionary, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if ([menuAsDictionary[kOGMenuManagerMenuNameKey] isEqualToString:menuName])
             {
                 menuIdentifier = idx;
                 *stop = YES;
             }
         }];
    }
    else
    {
        menuIdentifier = kOGMenuManagerMainMenuIdentifier;
    }
    
    if (!self.audioManager.isMusicPlaying)
    {
        [self.audioManager playMusic:kOGMenuManagerBackgroundMusic];
        self.audioManager.musicPlayerDelegate = self;
    }
    
    [self loadMenuWithIdentifier:menuIdentifier];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag)
    {
        [player play];
    }
}

@end
