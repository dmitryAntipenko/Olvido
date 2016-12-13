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
#import "OGConstants.h"

NSString *const kGKSceneGraphsKey = @"Graphs";

@implementation GKScene (OGFactory)

+ (instancetype)sceneWithMetadata:(OGSceneMetadata *)metadata userDeviceIdiom:(UIUserInterfaceIdiom)idiom;
{
    NSString *fileName = [[NSString alloc] initWithFormat:@"%@%@",
                          metadata.fileName,
                          [OGConstants sceneSuffixForInterfaceIdiom:idiom]];
    
    GKScene *gkScene = [self sceneWithFileNamed:fileName];
    
    SKScene *skScene = (SKScene *)gkScene.rootNode;
    
    if (!skScene.userData)
    {
        skScene.userData = [NSMutableDictionary dictionary];
    }
    
    [skScene.userData setObject:gkScene.graphs forKey:kGKSceneGraphsKey];
    
    return gkScene;
}

+ (instancetype)sceneWithMetadata:(OGSceneMetadata *)metadata
{
    return [self sceneWithMetadata:metadata userDeviceIdiom:UIUserInterfaceIdiomUnspecified];
}

@end
