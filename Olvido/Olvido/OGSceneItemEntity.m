//
//  OGSceneItemEntity.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 12/2/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneItemEntity.h"
#import "OGRenderComponent.h"
#import "OGPhysicsComponent.h"
#import "OGColliderType.h"

@interface OGSceneItemEntity ()

@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;

@end

@implementation OGSceneItemEntity

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
{
    if (spriteNode)
    {
        self = [super init];
        
        if (self)
        {
            _renderComponent = [[OGRenderComponent alloc] init];
            _renderComponent.node = spriteNode;
            [self addComponent:_renderComponent];
            
            _physicsComponent = [[OGPhysicsComponent alloc] initWithPhysicsBody:spriteNode.physicsBody
                                                                   colliderType:[OGColliderType sceneItem]];
            [self addComponent:_physicsComponent];
            
            NSArray *contactColliders = @[[OGColliderType player]];
            [[OGColliderType requestedContactNotifications] setObject:contactColliders forKey:[OGColliderType sceneItem]];
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
}

- (void)contactWithEntityDidEnd:(GKEntity *)entity
{
}

@end
