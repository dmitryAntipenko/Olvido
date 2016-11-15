//
//  GKScene+OGFactory.m
//  Olvido
//
//  Created by Алексей Подолян on 11/15/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "GKScene+OGFactory.h"
#import "OGGKGameScene.h"
#import "OGGKGameScene.h"
#import "OGSceneMetadata.h"
#import "OGGameScene.h"

@implementation GKScene (OGFactory)

+ (instancetype)sceneWithMetadata:(OGSceneMetadata *)metadata;
{
    GKScene *result = nil;
    
    if (metadata)
    {
        if ([metadata.sceneClass isSubclassOfClass:OGGameScene.self])
        {
            result = [OGGKGameScene sceneWithFileNamed:metadata.fileName];
        }
        else
        {
            result = [self sceneWithFileNamed:metadata.fileName];
        }
    }
    
    return result;
}

@end
