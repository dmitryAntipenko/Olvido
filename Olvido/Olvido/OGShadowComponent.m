//
//  OGShadowComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGShadowComponent.h"
#import "OGLightBitMask.h"

CGFloat const OGShadowComponentAlpha = 0.25;

@implementation OGShadowComponent

- (instancetype)initWithTexture:(SKTexture *)texture offset:(CGFloat)offset
{
    self = [super init];
    
    if (self)
    {
        _node = [SKSpriteNode spriteNodeWithTexture:texture];
        _node.alpha = OGShadowComponentAlpha;
        _node.position = CGPointMake(0.0, offset);
    }
    
    return self;
}

@end
