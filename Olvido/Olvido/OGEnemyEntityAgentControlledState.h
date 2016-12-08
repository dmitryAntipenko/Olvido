//
//  OGEnemyEntityAgentControlledState.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/15/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
@class OGEnemyEntity;
@class OGWeaponComponent;

@interface OGEnemyEntityAgentControlledState : GKState

@property (nonatomic, weak, readonly) OGEnemyEntity *enemyEntity;
@property (nonatomic, weak, readonly) OGWeaponComponent *weaponComponent;

- (instancetype)initWithEnemyEntity:(OGEnemyEntity *)enemyEntity;

@end
