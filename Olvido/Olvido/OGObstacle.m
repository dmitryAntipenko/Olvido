//
//  OGObstacle.m
//  Olvido
//
//  Created by Александр Песоцкий on 12/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGObstacle.h"

#import "OGColliderType.h"

#import "OGRenderComponent.h"
#import "OGPhysicsComponent.h"

@interface OGObstacle ()

@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;

@end

@implementation OGObstacle

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
{
    self = [super init];
    
    if (self)
    {
        spriteNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:spriteNode.size];
        
        NSArray *contactColliders = @[[OGColliderType player]];
        [[OGColliderType requestedContactNotifications] setObject:contactColliders forKey:[OGColliderType obstacle]];
        
        _renderComponent = [[OGRenderComponent alloc] init];
        _renderComponent.node = spriteNode;
        
        [self addComponent:_renderComponent];
        
        _physicsComponent = [[OGPhysicsComponent alloc] initWithPhysicsBody:_renderComponent.node.physicsBody
                                                               colliderType:[OGColliderType obstacle]];
        _physicsComponent.physicsBody.dynamic = NO;
        
        [self addComponent:_physicsComponent];
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
