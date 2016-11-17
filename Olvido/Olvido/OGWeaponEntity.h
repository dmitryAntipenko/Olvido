//
//  OGBlaster.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/12/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGAttacking.h"
#import "OGInventoryItem.h"
#import "OGEntityManaging.h"

@class OGAnimationComponent;
@class OGRenderComponent;
@class OGPhysicsComponent;
@class OGSoundComponent;

@interface OGWeaponEntity : GKEntity <OGAttacking, OGInventoryItem>

@property (nonatomic, strong, readonly) NSString *inventoryIdentifier;

@property (nonatomic, weak) id<OGEntityManaging> delegate;

@property (nonatomic, weak) GKEntity *owner;

@property (nonatomic, strong) OGRenderComponent *render;
@property (nonatomic, strong) OGPhysicsComponent *physics;
@property (nonatomic, strong) OGAnimationComponent *animation;
@property (nonatomic, strong) OGSoundComponent *sound;

- (instancetype)initWithSpriteNode:(SKSpriteNode *)sprite;

@end
