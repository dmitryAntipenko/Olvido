//
//  OGObstacle.h
//  Olvido
//
//  Created by Александр Песоцкий on 12/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGContactNotifiableType.h"

@class OGPhysicsComponent;

@interface OGObstacle : GKEntity <OGContactNotifiableType>

@property (nonatomic, strong, readonly) OGPhysicsComponent *physicsComponent;

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode;

@end
