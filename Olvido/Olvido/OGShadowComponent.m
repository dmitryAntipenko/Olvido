//
//  OGShadowComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGShadowComponent.h"

CGFloat const kOGShadowComponentAlpha = 0.25;

@implementation OGShadowComponent

- (instancetype)initWithTexture:(SKTexture *)texture offset:(CGPoint)offset
{
    self = [super init];
    
    if (self)
    {
        _node = [SKSpriteNode spriteNodeWithTexture:texture];
        _node.alpha = kOGShadowComponentAlpha;
        _node.position = offset;
    }
    
    return self;
}

@end
