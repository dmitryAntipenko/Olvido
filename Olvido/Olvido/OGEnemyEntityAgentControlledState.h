//
//  OGEnemyEntityAgentControlledState.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/15/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
@class OGEnemyEntity;

@interface OGEnemyEntityAgentControlledState : GKState

- (instancetype)initWithEnemyEntity:(OGEnemyEntity *)enemyEntity;

@end
