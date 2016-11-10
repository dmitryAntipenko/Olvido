//
//  OGLoadingScene.h
//  Olvido
//
//  Created by Алексей Подолян on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGBaseScene.h"

@class OGSceneLoader;
@class OGSceneManager;

@interface OGLoadingScene : OGBaseScene

@property (nonatomic, weak) OGSceneManager *sceneManager;

+ (instancetype)loadingSceneWithSceneLoader:(OGSceneLoader *)sceneLoader;

@end
