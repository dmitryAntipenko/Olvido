//
//  OGEnemyEntityDieState.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/23/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
@class OGEnemyEntity;

@interface OGEnemyEntityDieState : GKState

- (instancetype)initWithEnemyEntity:(OGEnemyEntity *)enemyEntity;

@end
