//
//  OGStoryScene.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/24/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGStoryScene.h"
#import "OGLevelManager.h"

NSString *const OGStorySceneDarknessNode = @"Darkness";

@implementation OGStoryScene

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
}

- (void)update:(NSTimeInterval)currentTime
{
//    if (![self childNodeWithName:OGStorySceneDarknessNode].hasActions)
//    {
//        [self.sceneDelegate storySceneDidCallFinish];
//    }
}

- (void)skipStory
{
    self.scene.paused = YES;
    [self.sceneDelegate storySceneDidCallFinish];
}

@end
