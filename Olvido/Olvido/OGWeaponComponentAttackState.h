//
//  OGWeaponComponentAttackState.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class OGWeaponComponent;

@interface OGWeaponComponentAttackState : GKState

- (instancetype)initWithWeaponComponent:(OGWeaponComponent *)weaponComponent;

@end
