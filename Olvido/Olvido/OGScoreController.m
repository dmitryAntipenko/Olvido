//
//  OGScoreController.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/5/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGScoreController.h"
#import "OGLevelController.h"
#import "OGConstants.h"

@interface OGScoreController ()

@property (nonatomic, retain, readwrite) NSNumber *score;
@property (nonatomic, retain) OGLevelController *levelController;
@property (nonatomic, readonly) NSNumber *randomLevelNumber;

@end

@implementation OGScoreController

- (instancetype)initWithLevelController:(OGLevelController *)levelController
{
    self = [super init];
    
    if (self)
    {
        _score = @(0);
        _levelController = [levelController retain];
    }
    else
    {
        [self release];
        self = nil;
    }
    
    return self;
}

- (void)incrementScore
{
    self.score = @(self.score.integerValue + 1);
    
    if (self.score.integerValue % kOGLevelControllerLevelChangeInterval == 0)
    {
        [self.levelController loadLevelWithNumber:self.randomLevelNumber];
    }
}

- (NSNumber *)randomLevelNumber
{
    return @(rand() % kOGLevelsCount + 1);
}

- (void)dealloc
{
    [_score release];
    [_levelController release];
    
    [super dealloc];
}

@end
