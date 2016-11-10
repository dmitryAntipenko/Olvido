//
//  OGLoadSceneOperation.h
//  Olvido
//
//  Created by Алексей Подолян on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OGSceneMetadata;
@class OGBaseScene;

@interface OGLoadSceneOperation : NSOperation

@property (nonatomic, strong, readonly) OGBaseScene *scene;

+ (instancetype)loadSceneOperationWithSceneMetadata:(OGSceneMetadata *)sceneMetadata;

@end
