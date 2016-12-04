//
//  OGShootingWeapon.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/29/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGWeaponEntity.h"

@class OGWeaponConfiguration;

@interface OGShootingWeapon : OGWeaponEntity

- (instancetype)initWithSpriteNode:(SKSpriteNode *)sprite configuration:(OGWeaponConfiguration *)configuration;

@end
