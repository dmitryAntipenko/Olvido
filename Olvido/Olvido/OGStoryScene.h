//
//  OGStoryScene.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/24/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGGameSceneStoryDelegate.h"
#import "OGBaseScene.h"

@interface OGStoryScene : OGBaseScene

@property (nonatomic, strong) id<OGGameSceneStoryDelegate> sceneDelegate;

- (void)skipStory;

@end
