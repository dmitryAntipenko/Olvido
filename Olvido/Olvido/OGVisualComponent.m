//
//  OGVisualComponent.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGVisualComponent.h"
#import "OGSpriteNode.h"

@implementation OGVisualComponent

- (void)dealloc
{
    [_spriteNode release];
    [_color release];
    
    [super dealloc];
}

- (void)setColor:(SKColor *)color
{
    if (_color != color)
    {
        [_color release];
        _color = [color retain];
        self.spriteNode.color = color;
        self.spriteNode.colorBlendFactor = 1.0;
    }
}

@end
