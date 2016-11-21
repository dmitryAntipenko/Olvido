//
//  OGPhysicsComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGColliderType.h"

@interface OGPhysicsComponent : GKComponent

@property (nonatomic, strong, readonly) SKPhysicsBody *physicsBody;

- (instancetype)initWithPhysicsBody:(SKPhysicsBody *)body colliderType:(OGColliderType *)type;

@end
