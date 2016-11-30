//
//  OGParticlesZoneEntity.m
//  Olvido
//
//  Created by Алексей Подолян on 11/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGParticlesZoneEntity.h"
#import "OGRenderComponent.h"

@implementation OGParticlesZoneEntity

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
                 affectedColliders:(NSArray<Class> *)affectedColliders
             interactionBeginBlock:(void (^)(GKEntity *entity))interactionBeginBlock
               interactionEndBlock:(void (^)(GKEntity *entity))interactionEndBlock
                           emitter:(SKEmitterNode *)emitter
{
    self = [super initWithSpriteNode:spriteNode affectedColliders:affectedColliders
               interactionBeginBlock:interactionBeginBlock
                 interactionEndBlock:interactionEndBlock];
    
//    if (self)
//    {
//        _renderComponent.node
//    }
//    
    return self;
}

@end
