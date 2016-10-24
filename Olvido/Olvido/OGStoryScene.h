//
//  OGStoryScene.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/24/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGGameSceneStoryDelegate.h"

@interface OGStoryScene : SKScene

@property (nonatomic, retain) id <OGGameSceneStoryDelegate> sceneDelegate;

@end
