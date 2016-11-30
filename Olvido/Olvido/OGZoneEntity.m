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
@property (nonatomic, strong) void (^interactionBeginBlock)(GKEntity *entity);
@property (nonatomic, strong) void (^interactionEndBlock)(GKEntity *entity);

@end

@implementation OGZoneEntity

#pragma mark - Init

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
                 affectedColliders:(NSArray<OGColliderType *> *)affectedColliders
             interactionBeginBlock:(void (^)(GKEntity *entity))interactionBeginBlock
               interactionEndBlock:(void (^)(GKEntity *entity))interactionEndBlock
{
    if (spriteNode && affectedColliders && interactionBeginBlock && interactionEndBlock)
    {
        self = [super init];
        
        if (self)
        {
            _interactionBeginBlock = interactionBeginBlock;
            _interactionEndBlock = interactionEndBlock;
            
            _renderComponent = [[OGRenderComponent alloc] init];
            _renderComponent.sortableByZ = NO;
            _renderComponent.node.position = spriteNode.position;
            _renderComponent.node.zPosition = spriteNode.zPosition;
            
            [spriteNode.parent addChild:_renderComponent.node];
            [spriteNode removeFromParent];
            
            spriteNode.position = CGPointZero;
            [_renderComponent.node addChild:spriteNode];
            
            [self addComponent:_renderComponent];
            
            SKPhysicsBody *physicsBody =  [SKPhysicsBody bodyWithTexture:spriteNode.texture size:spriteNode.texture.size];
            physicsBody.usesPreciseCollisionDetection = YES;
            
            OGColliderType *colliderType = [OGColliderType zone];
            [[OGColliderType requestedContactNotifications] setObject:affectedColliders forKey:colliderType];
            
            _physicsComponent = [[OGPhysicsComponent alloc] initWithPhysicsBody:physicsBody colliderType:colliderType];
            
            _renderComponent.node.physicsBody = physicsBody;//will removed after physict component add physics body to render node
            
            [self addComponent:_physicsComponent];
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

- (instancetype)init
{
    return [self initWithSpriteNode:nil affectedColliders:nil interactionBeginBlock:nil interactionEndBlock:nil];
}

#pragma mark - OGContactNotifiableType

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    self.interactionBeginBlock(entity);
}

- (void)contactWithEntityDidEnd:(GKEntity *)entity
{
    self.interactionEndBlock(entity);
}

@end
