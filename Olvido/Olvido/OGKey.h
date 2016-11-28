//
//  OGKey.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGInventoryItem.h"

@class OGRenderComponent;
@class OGKeyComponent;
@class OGPhysicsComponent;

@interface OGKey : GKEntity <OGInventoryItem>

@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;
@property (nonatomic, strong) OGKeyComponent *keyComponent;

- (instancetype)initWithSpriteNode:(SKSpriteNode*)spriteNode;

@end
