//
//  OGGameScene.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGGameSceneDelegate.h"
#import "OGPortalPosition.h"
@class OGEnemyEntity;

@interface OGGameScene : SKScene

@property (nonatomic, retain) NSNumber *identifier;

@property (nonatomic, retain) id <OGGameSceneDelegate> sceneDelegate;

@property (nonatomic, retain) SKNode *player;
@property (nonatomic, retain) NSArray<OGEnemyEntity *> *enemies;
@property (nonatomic, retain) NSArray *portals;

- (void)createSceneContents;

- (void)addPortalWithPosition:(OGPortalPosition)position nextLevelIdentifier:(NSNumber *)identifier;

@end
