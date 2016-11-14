//
//  OGThumbStickNode.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGThumbStickNode.h"

CGFloat const kOGThumbStickNodeDefaultAlpha = 0.2;
CGFloat const kOGThumbStickNodeTouchedAlpha = 0.5;

@interface OGThumbStickNode ()

@property (nonatomic, strong) SKSpriteNode *touchPad;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat trackingDistance;
@property (nonatomic, assign) CGFloat normalAlpha;
@property (nonatomic, assign) CGFloat selectedAlpha;

@end

@implementation OGThumbStickNode

- (instancetype)initWithSize:(CGSize)size
{
    _trackingDistance = size.width / 2.0;
    CGFloat touchPadLength = size.width / 2.2;
    _center = CGPointMake(size.width / 2.0 - touchPadLength, size.height / 2.0 - touchPadLength);
    
    CGSize touchPadSize = CGSizeMake(touchPadLength, touchPadLength);
    SKTexture *touchPadTexture = [SKTexture textureWithImageNamed:@"ControlPad"];
    
    self = [super initWithTexture:touchPadTexture color:[SKColor clearColor] size:size];
    
    if (self)
    {
        _touchPad = [SKSpriteNode spriteNodeWithTexture:touchPadTexture size:touchPadSize];
        _touchPad.color = [SKColor clearColor];
        
        self.alpha = kOGThumbStickNodeDefaultAlpha;
        [self addChild:_touchPad];
    }
    
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    self.alpha = kOGThumbStickNodeTouchedAlpha;
    [self.thumbStickNodeDelegate thumbStickNode:self isPressed:YES];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    for (UITouch *touch in touches)
    {
        CGPoint touchLocation = [touch locationInNode:self];
        
        CGFloat dx = touchLocation.x - self.center.x;
        CGFloat dy = touchLocation.y - self.center.y;
        
        CGFloat distance = hypot(dx, dy);
        
        if (distance > self.trackingDistance)
        {
            dx = (dx / distance) * self.trackingDistance;
            dy = (dy / distance) * self.trackingDistance;
        }
        
        self.touchPad.position = CGPointMake(self.center.x + dx, self.center.y + dy);
        
        CGFloat normalizedDx = dx / self.trackingDistance;
        CGFloat normalizedDy = dy / self.trackingDistance;
        
        [self.thumbStickNodeDelegate thumbStickNode:self didUpdateXValue:normalizedDx yValue:normalizedDy];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (touches.count == 0)
    {
        return;
    }
    
    [self resetTouchPad];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];    
    [self resetTouchPad];
}

- (void)resetTouchPad
{
    self.alpha = kOGThumbStickNodeDefaultAlpha;
    
    SKAction *restoreToCenter = [SKAction moveTo:CGPointZero duration:0.2];
    [self.touchPad runAction:restoreToCenter];
        
    [self.thumbStickNodeDelegate thumbStickNode:self isPressed:NO];
    [self.thumbStickNodeDelegate thumbStickNode:self didUpdateXValue:0.0 yValue:0.0];
}

@end
