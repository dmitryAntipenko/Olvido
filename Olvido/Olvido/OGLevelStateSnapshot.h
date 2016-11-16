//
//  OGLevelStateSnapshot.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
@class OGGameScene;

extern NSString *const kOGLevelStateSnapshotEntitiesKey;
extern NSString *const kOGLevelStateSnapshotDistancesKey;

@interface OGLevelStateSnapshot : GKComponent

- (instancetype)initWithScene:(OGGameScene *)scene;

@property (nonatomic, strong, readonly) NSDictionary *snapshot;

@end
