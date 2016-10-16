//
//  OGGameScene.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGGameSceneDelegate.h"
#import "OGPortalLocation.h"

@class OGEntity;

@class OGPortal;

@interface OGGameScene : SKScene

@property (nonatomic, retain) NSNumber *identifier;

@property (nonatomic, retain) id <OGGameSceneDelegate> sceneDelegate;

@property (nonatomic, retain) SKNode *player;
@property (nonatomic, retain, readonly) NSMutableArray<OGEntity *> *enemies;
@property (nonatomic, retain, readonly) NSMutableArray<OGEntity *> *portals;

- (void)createSceneContents;

- (void)addPortal:(OGEntity *)portal;

@end
