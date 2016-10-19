//
//  OGMovementControlComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMovementControlComponent.h"

CGFloat const kOGMovementControlComponentDefaultSpeedFactor = 1.0;

@implementation OGMovementControlComponent

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
{
    self = [super init];
    
    if (self)
    {
        _spriteNode = [spriteNode retain];
        _speedFactor = kOGMovementControlComponentDefaultSpeedFactor;
    }
    
    return self;
}


#pragma mark subclasses should implement

- (void)touchBeganAtPoint:(CGPoint)point
{
    
}

- (void)touchEndedAtPoint:(CGPoint)point
{
    
}

- (void)touchMovedToPoint:(CGPoint)point
{
    
}

- (void)stop
{
    
}

- (void)setSpeedFactor:(CGFloat)speedFactor
{
    _speedFactor = speedFactor;
    
    if (self.spriteNode)
    {
        CGVector velocity = self.spriteNode.physicsBody.velocity;
        self.spriteNode.physicsBody.velocity = CGVectorMake(velocity.dx * speedFactor, velocity.dy * speedFactor);
    }
}

- (void)dealloc
{
    [_spriteNode release];
    
    [super dealloc];
}

@end
