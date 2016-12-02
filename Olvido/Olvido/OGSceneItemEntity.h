//
//  OGSceneItemEntity.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 12/2/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGContactNotifiableType.h"
#import "OGEntityManaging.h"

@class OGRenderComponent;
@class OGPhysicsComponent;

@interface OGSceneItemEntity : GKEntity <OGContactNotifiableType>

@property (nonatomic, strong, readonly) OGRenderComponent *renderComponent;
@property (nonatomic, strong, readonly) OGPhysicsComponent *physicsComponent;

@property (nonatomic, weak) id<OGEntityManaging> delegate;

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode;

@end
