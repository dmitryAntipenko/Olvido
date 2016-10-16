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

- (instancetype)initWithColor:(SKColor *)color
{
    self = [super init];
    
    if (self)
    {
        _color = [color retain];
    }
    
    return self;
}

- (void)dealloc
{
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
    }
}

@end
