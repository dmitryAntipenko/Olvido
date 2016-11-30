//
//  OGHiddenZoneEntity.m
//  Olvido
//
//  Created by Алексей Подолян on 11/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSpriteZoneEntity.h"
#import "OGColliderType.h"
#import "OGRenderComponent.h"

@implementation OGSpriteZoneEntity

@synthesize renderComponent = _renderComponent;

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
                 affectedColliders:(NSArray<OGColliderType *> *)affectedColliders
             interactionBeginBlock:(void (^)(GKEntity *entity))interactionBeginBlock
               interactionEndBlock:(void (^)(GKEntity *entity))interactionEndBlock
{
    self = [super initWithSpriteNode:spriteNode
                   affectedColliders:affectedColliders
               interactionBeginBlock:interactionBeginBlock
                 interactionEndBlock:interactionEndBlock];
    
    if (self)
    {
        [spriteNode removeFromParent];
        spriteNode.position = CGPointZero;
        
        [_renderComponent.node addChild:spriteNode];
    }
    
    return self;
}

@end
