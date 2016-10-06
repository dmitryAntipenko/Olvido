//
//  OGLevel.m
//  Olvido
//
//  Created by Алексей Подолян on 10/5/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLevel.h"
#import "OGObstacleNode.h"

@interface OGLevel ()

@property (nonatomic, copy) NSMutableArray<OGObstacleNode *> *mutableObstacles;

@end

@implementation OGLevel

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _mutableObstacles = [[NSMutableArray alloc] init];
    }
    else
    {
        [self release];
        self = nil;
    }
    
    return self;
}

- (BOOL)addObstacle:(OGObstacleNode *)obstacle
{
    BOOL result = NO;
    
    if (self.mutableObstacles && obstacle)
    {
        [self.mutableObstacles addObject:obstacle];
        result = YES;
    }
    
    return result;
}

- (NSArray<OGObstacleNode *> *)obstacles
{
    return [[_mutableObstacles copy] autorelease];
}

- (void)dealloc
{
    [_identifier release];
    
    [_backgroundColor release];
    [_accentColor release];
    [_playerColor release];
    [_enemyColor release];
    
    [_enemyCount release];
    
    [_mutableObstacles release];
    
    [super dealloc];
}

@end
