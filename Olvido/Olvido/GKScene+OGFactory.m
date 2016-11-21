//
//  GKScene+OGFactory.m
//  Olvido
//
//  Created by Алексей Подолян on 11/15/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "GKScene+OGFactory.h"
#import "OGSceneMetadata.h"
#import "OGGameScene.h"

NSString *const kGKSceneGraphsKey = @"Graphs";

@implementation GKScene (OGFactory)

+ (instancetype)sceneWithMetadata:(OGSceneMetadata *)metadata
{
    GKScene *gkScene = [self sceneWithFileNamed:metadata.fileName];
    
    SKScene *gameScene = (SKScene *)gkScene.rootNode;
    
    if (!gameScene.userData)
    {
        gameScene.userData = [NSMutableDictionary dictionary];
    }
    
    [gameScene.userData setObject:gkScene.graphs forKey:kGKSceneGraphsKey];
    
    return gkScene;
}

@end
