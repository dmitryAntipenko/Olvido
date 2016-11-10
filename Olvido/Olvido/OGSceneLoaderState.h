//
//  OGSceneLoaderState.h
//  Olvido
//
//  Created by Алексей Подолян on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGSceneLoader.h"

@interface OGSceneLoaderState : GKState

@property (nonatomic, strong, readonly) OGSceneLoader *sceneLoader;

+ (instancetype)stateWithSceneLoader:(OGSceneLoader *)sceneLoader;

@end
