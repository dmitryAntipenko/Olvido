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
@class OGGameScene;

@interface OGSceneItemEntity : GKEntity <OGContactNotifiableType>

@property (nonatomic, weak) OGGameScene *gameScene;

@property (nonatomic, strong, readonly) OGRenderComponent *renderComponent;
@property (nonatomic, strong, readonly) OGPhysicsComponent *physicsComponent;

@property (nonatomic, weak) id<OGEntityManaging> delegate;

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode;

@end

@protocol OGSceneItemsDelegate <NSObject>

- (void)itemWillBeTaken:(OGSceneItemEntity *)entity;

@end
