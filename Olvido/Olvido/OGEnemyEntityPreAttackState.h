//
//  OGEnemyEntityPreAttackState.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/18/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
@class OGEnemyEntity;

@interface OGEnemyEntityPreAttackState : GKState

- (instancetype)initWithEnemyEntity:(OGEnemyEntity *)enemyEntity;

@end
