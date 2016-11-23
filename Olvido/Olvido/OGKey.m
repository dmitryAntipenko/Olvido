//
//  OGKey.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGKey.h"
#import "OGRenderComponent.h"
#import "OGPhysicsComponent.h"
#import "OGColliderType.h"

@implementation OGKey

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
                                                                   colliderType:[OGColliderType key]];
            [self addComponent:_physicsComponent];
        }
    }
    
    return self;
}

- (NSString *)identifier
{
    return self.renderComponent.node.name;
}

- (SKTexture *)texture
{
    return ((SKSpriteNode *) self.renderComponent.node).texture;
}

- (void)wasTaken
{
    [self.renderComponent.node removeFromParent];
}

@end
