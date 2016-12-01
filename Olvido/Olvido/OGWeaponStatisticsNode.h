//
//  OGWeaponStatisticsNode.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/29/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGHUDElement.h"
#import "OGWeaponComponentObserving.h"

@class OGWeaponEntity;

@interface OGWeaponStatisticsNode : SKSpriteNode <OGHUDElement, OGWeaponComponentObserving>

@end
