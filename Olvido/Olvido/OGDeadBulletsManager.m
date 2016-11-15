//
//  OGDeadBulletsManager.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDeadBulletsManager.h"

@interface OGDeadBulletsManager ()

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation OGDeadBulletsManager

+ (instancetype)sharedManager
{
    static OGDeadBulletsManager *manager = nil;
    static dispatch_once_t dispatchOnceToken = 0;
    
    dispatch_once(&dispatchOnceToken, ^()
    {
        manager = [[OGDeadBulletsManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _items = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addItem:(OGBullet *)item
{
    if (item)
    {
        [self.items addObject:item];
    }
}

- (void)removeItem:(OGBullet *)item
{
    if (item)
    {
        [self.items removeObject:item];
    }
}

@end
