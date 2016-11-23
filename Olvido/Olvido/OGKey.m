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
            _render = [[OGRenderComponent alloc] init];
            _render.node = spriteNode;
            [self addComponent:_render];
            
            _physics = [[OGPhysicsComponent alloc] initWithPhysicsBody:spriteNode.physicsBody
                                                          colliderType:[OGColliderType key]];
            [self addComponent:_physics];
        }
    }
    
    return self;
}

- (NSString *)identifier
{
    return self.render.node.name;
}

- (SKTexture *)texture
{
    return ((SKSpriteNode *)self.render.node).texture;
}

- (void)wasTaken
{
    [self.render.node removeFromParent];
}

@end
