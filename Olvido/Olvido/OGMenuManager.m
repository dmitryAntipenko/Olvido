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

NSString *const kOGMenuManagerMenusMapName = @"MenusMap";
NSUInteger const kOGMenuManagermainMenuIdentifier = 0;

@interface OGMenuManager ()

@property (nonatomic, strong) NSArray *menusMap;

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
    [self loadMenuWithIdentifier:kOGMenuManagermainMenuIdentifier];
}

- (void)loadMenuWithIdentifier:(NSUInteger)menuIdentifier
{
    
}

- (void)loadMenuWithName:(NSString *)menuName
{
    
}

@end
