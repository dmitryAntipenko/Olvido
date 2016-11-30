//
//  OGAreaEntity.m
//  Olvido
//
//  Created by Алексей Подолян on 11/29/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGZoneEntity.h"
#import "OGRenderComponent.h"
#import "OGPhysicsComponent.h"
#import "OGZPositionEnum.m"
#import "OGColliderType.h"
#import "OGCollisionBitMask.h"

@interface OGZoneEntity ()

@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;

@end

@implementation OGZoneEntity

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
{
    if (spriteNode)
    {
        self = [self init];
        
        if (self)
        {
            _renderComponent = [[OGRenderComponent alloc] init];
            _renderComponent.node.position = spriteNode.position;
            _renderComponent.node.zPosition = OGZPositionCategoryBackground;
            
            SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithTexture:spriteNode.texture size:spriteNode.size];
            OGColliderType *colliderType = [OGColliderType zone];
            colliderType.collisionBitMask = OGCollisionBitMaskDefault;
            
            _physicsComponent = [[OGPhysicsComponent alloc] initWithPhysicsBody:physicsBody colliderType:];
            _physicsComponent.
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

@end
