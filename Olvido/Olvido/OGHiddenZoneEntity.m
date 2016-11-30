//
//  OGHiddenZoneEntity.m
//  Olvido
//
//  Created by Алексей Подолян on 11/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGHiddenZoneEntity.h"
#import "OGColliderType.h"

@implementation OGHiddenZoneEntity

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
    }
    
    return self;
}

@end
