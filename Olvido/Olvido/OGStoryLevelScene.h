//
//  OGStoryLevelScene.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OGStoryLevelScene : SKScene

@property (nonatomic, copy, readonly) NSArray<SKSpriteNode *> *performers;

- (void)runStoryWithSceneStory:(NSMutableDictionary *)sceneStory;

- (void)addPerformer:(SKSpriteNode *)performer;

@end
