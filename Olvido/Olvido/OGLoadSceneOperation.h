//
//  OGLoadSceneOperation.h
//  Olvido
//
//  Created by Алексей Подолян on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGLoadOperation.h"

@class OGSceneMetadata;
@class OGBaseScene;

@interface OGLoadSceneOperation : OGLoadOperation

@property (nonatomic, strong, readonly) OGBaseScene *scene;
@property (nonatomic, strong, readonly) NSProgress *progress;

+ (instancetype)loadSceneOperationWithSceneMetadata:(OGSceneMetadata *)sceneMetadata;

@end
