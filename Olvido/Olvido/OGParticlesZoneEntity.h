//
//  OGParticlesZoneEntity.h
//  Olvido
//
//  Created by Алексей Подолян on 11/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGHiddenZoneEntity.h"

@interface OGParticlesZoneEntity : OGHiddenZoneEntity

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
                 affectedColliders:(NSArray<Class> *)affectedColliders
             interactionBeginBlock:(void (^)(GKEntity *entity))interactionBeginBlock
               interactionEndBlock:(void (^)(GKEntity *entity))interactionEndBlock
                           emitter:(SKEmitterNode *)emitter NS_DESIGNATED_INITIALIZER;

@end
