//
//  OGGameState.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/19/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
@class OGScenesController;

@interface OGGameState : GKState

@property (nonatomic, retain) OGScenesController *scenesController;

- (instancetype)initWithView:(SKView *)view;

@end
