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

NSString *const kOGMenuManagerMenuNameKey = @"MenuName";
NSString *const kOGMenuManagerSceneIdentifierKey = @"SceneIdentifier";
NSString *const kOGMenuManagerMenusMapName = @"MenusMap";
NSUInteger const kOGMenuManagerMainMenuIdentifier = 0;

@interface OGMenuManager ()

@property (nonatomic, strong) NSArray<NSDictionary *> *menusMap;

@end

@implementation OGMenuManager

+ (instancetype)menuManager
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:kOGMenuManagerMenusMapName
                                                              ofType:kOGPropertyFileExtension];
        _menusMap = [NSArray arrayWithContentsOfFile:plistPath];
    }
    
    return self;
}

- (void)loadMainMenu
{
    [self loadMenuWithIdentifier:kOGMenuManagerMainMenuIdentifier];
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
    
    [self.sceneManager transitionToSceneWithIdentifier:sceneIdentifer];
}

@end
