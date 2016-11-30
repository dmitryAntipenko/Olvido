//
//  OGWeaponComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/12/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGAttacking.h"
#import "OGWeaponEntity.h"
#import "OGWeaponComponentObserving.h"

@interface OGWeaponComponent : GKComponent

@property (nonatomic, strong) OGWeaponEntity *weapon;
@property (nonatomic, weak) id<OGWeaponComponentObserving> weaponObserver;

@property (nonatomic, assign) BOOL shouldAttack;

@property (nonatomic, assign) CGVector attackDirection;
@property (nonatomic, assign) CGFloat attackSpeed;
@property (nonatomic, assign) NSUInteger charge;
@property (nonatomic, assign) NSUInteger maxCharge;

@property (nonatomic, assign, readonly) CGFloat reloadSpeed;

@end
