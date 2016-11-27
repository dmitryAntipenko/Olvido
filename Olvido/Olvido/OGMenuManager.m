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

NSString *const OGMenuManagerMenuNameKey = @"Name";
NSString *const OGMenuManagerSceneIdentifierKey = @"SceneIdentifier";
NSString *const OGMenuManagerMenusMapName = @"MenusMap";
NSString *const OGMenuManagerMainMenuName = @"OGMainMenuScene";
NSUInteger const OGMenuManagerMainMenuIdentifier = 0;
NSString *const OGMenuManagerBackgroundMusic = @"menu_music";

@interface OGMenuManager () <AVAudioPlayerDelegate>

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

- (void)loadMenuMap
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:OGMenuManagerMenusMapName
                                                          ofType:OGPropertyFileExtension];
    self.menusMap = [NSArray arrayWithContentsOfFile:plistPath];
}

- (void)loadMainMenu
{
    [self loadMenuWithName:OGMenuManagerMainMenuName];
}

- (void)loadMenuWithIdentifier:(NSUInteger)menuIdentifier
{
    NSUInteger sceneIdentifer = [self.menusMap[menuIdentifier][OGMenuManagerSceneIdentifierKey] integerValue];
    
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
             if ([menuAsDictionary[OGMenuManagerMenuNameKey] isEqualToString:menuName])
             {
                 menuIdentifier = idx;
                 *stop = YES;
             }
         }];
    }
    else
    {
        menuIdentifier = OGMenuManagerMainMenuIdentifier;
    }
    
    if (!self.audioManager.isMusicPlaying)
    {
        [self.audioManager playMusic:OGMenuManagerBackgroundMusic];
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
