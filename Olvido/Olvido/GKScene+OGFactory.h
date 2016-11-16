//
//  GKScene+OGFactory.h
//  Olvido
//
//  Created by Алексей Подолян on 11/15/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class OGSceneMetadata;

@interface GKScene (OGFactory)

+ (instancetype)sceneWithMetadata:(OGSceneMetadata *)metadata;

@end
