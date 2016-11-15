//
//  OGGKGameScene.m
//  Olvido
//
//  Created by Алексей Подолян on 11/15/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGKGameScene.h"
#import "OGGameScene.h"

@implementation OGGKGameScene

+ (instancetype)sceneWithFileNamed:(NSString *)filename
{
    OGGKGameScene *gkScene = [super sceneWithFileNamed:filename];
    
    OGGameScene *gameScene = (OGGameScene *)gkScene.rootNode;
    gameScene.graphs = gkScene.graphs;
    
    return gkScene;
}

@end
