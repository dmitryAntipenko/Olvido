//
//  OGShootingButtonNode.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/12/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGActionButtonNode.h"

CGFloat const kOGActionButtonNodeDefaultAlpha = 0.2;
CGFloat const kOGActionButtonNodeTouchedAlpha = 0.5;

@interface OGActionButtonNode ()

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat normalAlpha;
@property (nonatomic, assign) CGFloat selectedAlpha;

@end

@implementation OGActionButtonNode

- (instancetype)initWithSize:(CGSize)size
{
    _center = CGPointMake(size.width / 2.0, size.height / 2.0);
    
    SKTexture *touchPadTexture = [SKTexture textureWithImageNamed:@"ControlPad"];
    
    self = [super initWithTexture:touchPadTexture color:[SKColor clearColor] size:size];
    
    if (self)
    {
        self.alpha = kOGActionButtonNodeDefaultAlpha;
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
    
    self.alpha = kOGActionButtonNodeTouchedAlpha;
    [self.actionButtonNodeDelegate actionButtonNode:self isPressed:YES];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self resetButton];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self resetButton];
}

- (void)resetButton
{
    self.alpha = kOGActionButtonNodeDefaultAlpha;
    [self.actionButtonNodeDelegate actionButtonNode:self isPressed:NO];
}

@end

