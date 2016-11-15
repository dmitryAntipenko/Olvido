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

@interface OGWeaponComponent : GKComponent

@property (nonatomic, strong) OGWeaponEntity *weapon;
@property (nonatomic, assign) BOOL shouldAttack;
@property (nonatomic, assign) CGVector attackDirection;
@property (nonatomic, assign) CGFloat attackSpeed;

@end
