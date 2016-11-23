//
//  OGBaseScene.h
//  Olvido
//
//  Created by Алексей Подолян on 11/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGBaseScene : SKScene <GKSceneRootNodeType>

@property (nonatomic, assign) BOOL customPaused;

- (void)configureScene;

- (void)pause;
- (void)resume;

@end
