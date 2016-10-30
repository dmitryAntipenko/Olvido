//
//  OGStoryScene.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/24/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGStoryScene.h"

NSString *const kOGStorySceneDarknessNode = @"Darkness";

@implementation OGStoryScene

- (void)update:(NSTimeInterval)currentTime
{
    if (![self childNodeWithName:kOGStorySceneDarknessNode].hasActions)
    {
        [self.sceneDelegate gameSceneDidFinishRunStory];
    }
}

- (void)skipStory
{
    self.scene.paused = YES;
    [self.sceneDelegate gameSceneDidFinishRunStory];
}

- (void)dealloc
{
    [_sceneDelegate release];
    
    [super dealloc];
}

@end
