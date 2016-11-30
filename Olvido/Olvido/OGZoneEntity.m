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

@property (nonatomic, strong) NSArray<Class> *affectedEntities;
@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;
@property (nonatomic, strong) void (^interactionBeginBlock)(GKEntity *entity);
@property (nonatomic, strong) void (^interactionEndBlock)(GKEntity *entity);

@end

@implementation OGZoneEntity

#pragma mark - Init

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
                  affectedEntities:(NSArray<Class> *)affectedEntities
             interactionBeginBlock:(void (^)(GKEntity *entity))interactionBeginBlock
               interactionEndBlock:(void (^)(GKEntity *entity))interactionEndBlock
{
    return [self initWithSpriteNode:spriteNode affectedEntities:affectedEntities interactionBeginBlock:interactionBeginBlock interactionEndBlock:interactionEndBlock particleEmitter:nil];
}

- (instancetype)init
{
    return [self initWithSpriteNode:nil affectedEntities:nil interactionBeginBlock:nil interactionEndBlock:nil];
}

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
                  affectedEntities:(NSArray<Class> *)affectedEntities
             interactionBeginBlock:(void (^)(GKEntity *entity))interactionBeginBlock
               interactionEndBlock:(void (^)(GKEntity *entity))interactionEndBlock
                   particleEmitter:(SKEmitterNode *)particleEmitter
{
    if (spriteNode && affectedEntities && interactionBeginBlock && interactionEndBlock)
    {
        self = [super init];
        
        if (self)
        {
            _interactionBeginBlock = interactionBeginBlock;
            _interactionEndBlock = interactionEndBlock;
            _affectedEntities = [affectedEntities copy];
            
            _renderComponent = [[OGRenderComponent alloc] init];
            _renderComponent.sortableByZ = NO;
            
            if (particleEmitter)
            {
                SKCropNode *cropNode = [SKCropNode node];
                cropNode.maskNode = spriteNode;
                cropNode.position = spriteNode.position;
                cropNode.zPosition = spriteNode.zPosition;
                
                [spriteNode removeFromParent];
                [cropNode addChild:spriteNode];
                _renderComponent.node = cropNode;
            }
            else
            {
                _renderComponent.node = spriteNode;
            }
            [self addComponent:_renderComponent];
            
            SKPhysicsBody *physicsBody =  [SKPhysicsBody bodyWithTexture:spriteNode.texture size:spriteNode.texture.size];
            physicsBody.usesPreciseCollisionDetection = YES;
            
            OGColliderType *colliderType = [OGColliderType zone];
            NSArray *contactColliders = @[[OGColliderType player], [OGColliderType enemy]];
            [[OGColliderType requestedContactNotifications] setObject:contactColliders forKey:colliderType];
            
            _physicsComponent = [[OGPhysicsComponent alloc] initWithPhysicsBody:physicsBody colliderType:colliderType];
            
            _renderComponent.node.physicsBody = physicsBody;
            [self addComponent:_physicsComponent];
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

#pragma mark - OGContactNotifiableType

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    if ([self.affectedEntities containsObject:entity.class])
    {
        self.interactionBeginBlock(entity);
    }
}

- (void)contactWithEntityDidEnd:(GKEntity *)entity
{
    if ([self.affectedEntities containsObject:entity.class])
    {
        self.interactionEndBlock(entity);
    }
}

@end
