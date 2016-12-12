//
//  OGZone.h
//  Olvido
//
//  Created by Алексей Подолян on 12/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGContactNotifiableType.h"

@class OGRenderComponent;
@class OGPhysicsComponent;
@class OGColliderType;

@interface OGZone : GKEntity <OGContactNotifiableType>

@property (nonatomic, strong, readonly) OGRenderComponent *renderComponent;
@property (nonatomic, strong, readonly) OGPhysicsComponent *physicsComponent;

#pragma mark - Factory

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
            affectingColliderTypes:(NSArray<OGColliderType *> *)affectingColliderTypes NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode;

+ (instancetype)zoneWithSpriteNode:(SKSpriteNode *)spriteNode zoneType:(NSString *)zoneType;

#pragma mark - Pause Resume

- (void)pause;

- (void)resume;

@end
