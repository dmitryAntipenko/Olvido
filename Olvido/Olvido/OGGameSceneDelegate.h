//
//  OGGameSceneDelegate.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#ifndef OGGameSceneDelegate_h
#define OGGameSceneDelegate_h

@class OGEntity;

@protocol OGGameSceneDelegate <NSObject>

- (void)gameSceneDidCallFinishWithPortal:(OGEntity *)portal;
- (void)gameSceneDidCallFinishGameWithScore:(NSNumber *)score;

@end

#endif /* OGGameSceneDelegate_h */
