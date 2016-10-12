//
//  OGScoreController.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/5/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGScoreController.h"
#import "OGConstants.h"

NSNumber *const kOGScoreControllerDefaultScore = 0;
NSInteger const kOGScoreControllerScoreIncrement = 1;

@interface OGScoreController ()

@property (nonatomic, retain, readwrite) NSNumber *score;
@property (nonatomic, readonly) NSNumber *randomLevelNumber;

@end

@implementation OGScoreController

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _score = kOGScoreControllerDefaultScore;
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
    self.score = @(self.score.integerValue + kOGScoreControllerScoreIncrement);
}

- (NSNumber *)randomLevelNumber
{
    return @(rand() % rand() + 1);
}

- (void)dealloc
{
    [_score release];
    
    [super dealloc];
}

@end
