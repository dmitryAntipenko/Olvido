//
//  OGShadowComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGShadowComponent : GKComponent

@property (nonatomic, strong) SKSpriteNode *node;
@property (nonatomic, assign) BOOL needsCastShadow;

- (instancetype)initWithTexture:(SKTexture *)texture offset:(CGFloat)offset;

@end
