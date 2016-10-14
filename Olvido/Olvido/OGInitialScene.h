//
//  OGInitialScene.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGGameSceneDelegate.h"
#import "OGGameSceneProtocol.h"

@interface OGInitialScene : SKScene <OGGameScene>

@property (nonatomic, retain) NSNumber *identifier;

@property (nonatomic, retain) id <OGGameSceneDelegate> sceneDelegate;

@property (nonatomic, retain) SKNode *player;
@property (nonatomic, retain) NSArray *enemies;
@property (nonatomic, retain) NSArray *portals;

@end
