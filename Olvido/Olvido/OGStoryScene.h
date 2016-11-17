//
//  OGStoryScene.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/24/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGBaseScene.h"

@protocol OGGameSceneStoryDelegate <NSObject>

- (void)storySceneDidCallFinish;

@end

@interface OGStoryScene : OGBaseScene

@property (nonatomic, strong) id<OGGameSceneStoryDelegate> sceneDelegate;

- (void)skipStory;

@end
