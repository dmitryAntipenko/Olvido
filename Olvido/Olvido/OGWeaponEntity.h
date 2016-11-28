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

@interface OGWeaponEntity : GKEntity <OGAttacking>

@property (nonatomic, strong, readonly) NSString *inventoryIdentifier;

@property (nonatomic, weak) id<OGEntityManaging> delegate;

@property (nonatomic, weak) GKEntity *owner;

@property (nonatomic, assign, readonly) CGFloat attackSpeed;

- (instancetype)initWithSpriteNode:(SKSpriteNode *)sprite;

@end
