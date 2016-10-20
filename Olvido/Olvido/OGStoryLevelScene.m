//
//  OGStoryLevelScene.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGStoryLevelScene.h"

@interface OGStoryLevelScene ()

@property (nonatomic, retain) SKNode *storyNode;

@end

@implementation OGStoryLevelScene

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _storyNode = [[SKNode alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [_storyNode release];
    
    [super dealloc];
}



@end
