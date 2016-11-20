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

NSString *const kOGMenuManagerMenuNameKey = @"Name";
NSString *const kOGMenuManagerSceneIdentifierKey = @"SceneIdentifier";
NSString *const kOGMenuManagerMenusMapName = @"MenusMap";
NSString *const kOGMenuManagerMainMenuName = @"OGMainMenuScene";
NSUInteger const kOGMenuManagerMainMenuIdentifier = 0;
NSString *const kOGMenuManagerBackgroundMusic = @"menu_music";

@interface OGMenuManager () <AVAudioPlayerDelegate>

@property (nonatomic, strong, readwrite) OGAudioManager *audioManager;
@property (nonatomic, strong) NSArray<NSDictionary *> *menusMap;

@end

@implementation OGMenuManager

+ (instancetype)sharedInstance;
{
    static OGMenuManager *menuManager = nil;
    static dispatch_once_t dispatchOnceToken = 0;
    
    dispatch_once(&dispatchOnceToken, ^()
    {
        menuManager = [[OGMenuManager alloc] init];
        [menuManager loadMenuMap];
    });
    
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
    [self.sceneManager transitionToSceneWithIdentifier:sceneIdentifer];
}

- (void)loadMenuWithName:(NSString *)menuName
{
    __block NSUInteger sceneIdentifer = 0;
    
    if (menuName)
    {
        [self.menusMap enumerateObjectsUsingBlock:^(NSDictionary *menuAsDictionary, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if ([menuAsDictionary[kOGMenuManagerMenuNameKey] isEqualToString:menuName])
             {
                 sceneIdentifer = [menuAsDictionary[kOGMenuManagerSceneIdentifierKey] integerValue];
                 *stop = YES;
             }
         }];
    }
    else
    {
        sceneIdentifer = kOGMenuManagerMainMenuIdentifier;
    }
    
    if (!self.audioManager.isMusicPlaying)
    {
        [self.audioManager playMusic:kOGMenuManagerBackgroundMusic];
        self.audioManager.musicPlayerDelegate = self;
    }
    
    [self.sceneManager transitionToSceneWithIdentifier:sceneIdentifer];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag)
    {
        [player play];
    }
}

@end
