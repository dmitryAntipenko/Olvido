//
//  OGScoreController.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/5/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGScoreController.h"
#import "OGLevelController.h"

@interface OGScoreController ()

@property (nonatomic, retain, readwrite) NSNumber *score;
@property (nonatomic, assign) OGLevelController *levelController;

@end

@implementation OGScoreController

- (instancetype)initWithLevelController:(OGLevelController *)levelController
{
    if (self = [super init])
    {
        _score = @(0);
        _levelController = levelController;
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
}

@end
