//
//  OGParticlesZoneEntity.m
//  Olvido
//
//  Created by Алексей Подолян on 11/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGParticlesZoneEntity.h"
#import "OGRenderComponent.h"
#import "OGColliderType.h"

@implementation OGParticlesZoneEntity

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
                 affectedColliders:(NSArray<Class> *)affectedColliders
             interactionBeginBlock:(void (^)(GKEntity *entity))interactionBeginBlock
               interactionEndBlock:(void (^)(GKEntity *entity))interactionEndBlock
                           emitter:(SKEmitterNode *)emitter
{
    if (emitter)
    {
        self = [super initWithSpriteNode:spriteNode affectedColliders:affectedColliders
                   interactionBeginBlock:interactionBeginBlock
                     interactionEndBlock:interactionEndBlock];
        
        if (self)
        {
            SKCropNode *cropNode = [SKCropNode node];
            cropNode.position = spriteNode.position;
            
            spriteNode.position = CGPointZero;
            cropNode.maskNode = spriteNode;
            
            [cropNode addChild:emitter];
            
            OGRenderComponent *renderComponent = (OGRenderComponent *)[self componentForClass:[OGRenderComponent class]];
            renderComponent.node = cropNode;
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
                 affectedColliders:(NSArray<Class> *)affectedColliders
             interactionBeginBlock:(void (^)(GKEntity *))interactionBeginBlock
               interactionEndBlock:(void (^)(GKEntity *))interactionEndBlock
{
    return [self initWithSpriteNode:spriteNode
                  affectedColliders:affectedColliders
              interactionBeginBlock:interactionBeginBlock
                interactionEndBlock:interactionEndBlock
                            emitter:nil];
}

@end
