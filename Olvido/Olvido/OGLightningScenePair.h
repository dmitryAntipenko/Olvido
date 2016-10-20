//
//  OGLightningScenePair.h
//  Olvido
//
//  Created by Алексей Подолян on 10/19/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class OGSpriteNode;

@interface OGLightningScenePair : SKSpriteNode

+ (instancetype)pairWithSpriteNodeA:(OGSpriteNode *)spriteNodeA spriteNodeB:(OGSpriteNode *)spriteNodeB;

@property (nonatomic, assign, readonly) OGSpriteNode *spriteNodeA;
@property (nonatomic, assign, readonly) OGSpriteNode *spriteNodeB;

@end
