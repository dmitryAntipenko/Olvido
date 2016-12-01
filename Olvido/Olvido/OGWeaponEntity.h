//
//  OGBlaster.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/12/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGEntityManaging.h"
#import "OGAttacking.h"
#import "OGInventoryItem.h"

extern CGFloat const OGWeaponEntityDefaultAttackSpeed;
extern CGFloat const OGWeaponEntityDefaultReloadSpeed;

@interface OGWeaponEntity : GKEntity <OGAttacking, OGInventoryItem>

@property (nonatomic, strong, readonly) NSString *inventoryIdentifier;

@property (nonatomic, weak) id<OGEntityManaging> delegate;

@property (nonatomic, weak) GKEntity *owner;

@property (nonatomic, assign, readonly) CGFloat attackSpeed;
@property (nonatomic, assign, readonly) CGFloat reloadSpeed;
@property (nonatomic, assign) NSUInteger charge;
@property (nonatomic, assign) NSUInteger maxCharge;

- (instancetype)initWithSpriteNode:(SKSpriteNode *)sprite
                       attackSpeed:(CGFloat)attackSpeed
                       reloadSpeed:(CGFloat)reloadSpeed
                            charge:(NSUInteger)charge
                         maxCharge:(NSUInteger)maxCharge;

@end
