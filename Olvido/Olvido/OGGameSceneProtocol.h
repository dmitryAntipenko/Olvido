//
//  OGGameSceneProtocol.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#ifndef OGGameSceneProtocol_h
#define OGGameSceneProtocol_h

#import "OGPortalPosition.h"

@protocol OGGameScene <SKPhysicsContactDelegate>

@property (nonatomic, retain) NSNumber *identifier;

@property (nonatomic, retain) id <OGGameSceneDelegate> sceneDelegate;

@property (nonatomic, retain) SKNode *player;
@property (nonatomic, retain) NSArray *enemies;
@property (nonatomic, retain) NSArray *portals;

- (void)createSceneContents;

- (void)addPortalWithPosition:(OGPortalPosition)position nextLevelIdentifier:(NSNumber *)identifier;

@end

#endif /* OGGameSceneProtocol_h */
