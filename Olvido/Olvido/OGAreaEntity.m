//
//  OGAreaEntity.m
//  Olvido
//
//  Created by Алексей Подолян on 11/29/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGAreaEntity.h"
#import "OGRenderComponent.h"
#import "OGPhysicsComponent.h"
#import "OGZPositionEnum.m"

@interface OGAreaEntity ()

@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;

@end

@implementation OGAreaEntity

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
            
            _physicsComponent = [[OGPhysicsComponent alloc] initWithPhysicsBody:<#(SKPhysicsBody *)#> colliderType:<#(OGColliderType *)#>]
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

@end
