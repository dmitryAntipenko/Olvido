//
//  OGMenuManager.m
//  Olvido
//
//  Created by Алексей Подолян on 11/11/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMenuManager.h"
#import "OGSceneManager.h"
#import "OGConstants.h"
#import "OGMenuBaseScene.h"

NSString *const kOGMenuManagerMenuNameKey = @"Name";
NSString *const kOGMenuManagerSceneIdentifierKey = @"SceneIdentifier";
NSString *const kOGMenuManagerMenusMapName = @"MenusMap";
NSUInteger const kOGMenuManagerMainMenuIdentifier = 0;

@interface OGMenuManager ()

@property (nonatomic, strong) NSArray<NSDictionary *> *menusMap;
@property (nonatomic, strong) OGMenuBaseScene *currentScene;

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
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:kOGMenuManagerMenusMapName
                                                          ofType:kOGPropertyFileExtension];
    self.menusMap = [NSArray arrayWithContentsOfFile:plistPath];
}

- (void)loadMainMenu
{
    [self loadMenuWithIdentifier:kOGMenuManagerMainMenuIdentifier];
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
    
    [self loadMenuWithIdentifier:menuIdentifier];
}

@end
