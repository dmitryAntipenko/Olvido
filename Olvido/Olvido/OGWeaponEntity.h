//
//  OGBlaster.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/12/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGAttacking.h"
#import "OGInventoryItemProtocol.h"

@class OGAnimationComponent;
@class OGRenderComponent;
@class OGPhysicsComponent;

@interface OGWeaponEntity : GKEntity <OGAttacking, OGInventoryItemProtocol>

@property (nonatomic, strong, readonly) NSString *inventoryIdentifier;

@property (nonatomic, strong) OGRenderComponent *render;
@property (nonatomic, strong) OGPhysicsComponent *physics;
@property (nonatomic, strong) OGAnimationComponent *animation;

- (instancetype)initWithSpriteNode:(SKSpriteNode *)sprite;

@end
