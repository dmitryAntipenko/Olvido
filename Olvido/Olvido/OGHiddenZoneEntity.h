//
//  OGAreaEntity.h
//  Olvido
//
//  Created by Алексей Подолян on 11/29/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGContactNotifiableType.h"

@class OGRenderComponent;
@class OGPhysicsComponent;

@interface OGHiddenZoneEntity : GKEntity <OGContactNotifiableType>

@property (nonatomic, strong, readonly) OGRenderComponent *renderComponent;
@property (nonatomic, strong, readonly) OGPhysicsComponent *physicsComponent;

#pragma mark - Init

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
                 affectedColliders:(NSArray<Class> *)affectedColliders
             interactionBeginBlock:(void (^)(GKEntity *entity))interactionBeginBlock
               interactionEndBlock:(void (^)(GKEntity *entity))interactionEndBlock;

+ (instancetype)emptyZoneWithSpriteNode:(SKSpriteNode *)spriteNode;

@end
