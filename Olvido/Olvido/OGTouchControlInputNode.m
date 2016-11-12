//
//  OGTouchControlInputNode.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTouchControlInputNode.h"
#import "OGThumbStickNodeDelegate.h"
#import "OGThumbStickNode.h"
#import "OGActionButtonNode.h"
#import "OGActionButtonNodeDelegate.h"

@interface OGTouchControlInputNode () <OGThumbStickNodeDelegate, OGActionButtonNodeDelegate>

@property (nonatomic, strong) OGThumbStickNode *thumbStick;
@property (nonatomic, strong) OGActionButtonNode *actionButton;

@property (nonatomic, strong) NSMutableSet<UITouch *> *controlTouches;
@property (nonatomic, strong) NSMutableSet<UITouch *> *actionButtonTouches;

@property (nonatomic, assign) CGFloat centerDividerWidth;
@property (nonatomic, assign) BOOL shouldHideThumbStickNodes;

@end

@implementation OGTouchControlInputNode

- (instancetype)initWithFrame:(CGRect)frame thumbStickNodeSize:(CGSize)size
{
    self = [super initWithTexture:nil color:[SKColor clearColor] size:size];
    
    if (self)
    {
        _centerDividerWidth = frame.size.width / 4.5;
        
        CGFloat initialVerticalOffset = -size.height;
        CGFloat initialHorizontalOffset = frame.size.width / 2.0 - size.width;
        
        _controlTouches = [NSMutableSet set];
        _actionButtonTouches = [NSMutableSet set];
        
        _thumbStick = [[OGThumbStickNode alloc] initWithSize:size];
        _thumbStick.position = CGPointMake(-initialHorizontalOffset, initialVerticalOffset);
        
        _actionButton = [[OGActionButtonNode alloc] initWithSize:size];
        _actionButton.position = CGPointMake(initialHorizontalOffset, initialVerticalOffset);
        
        _actionButton.actionButtonNodeDelegate = self;
        _thumbStick.thumbStickNodeDelegate = self;
        
        [self addChild:_thumbStick];
        [self addChild:_actionButton];
    }
    
    return self;
}

- (void)setShouldHideThumbStickNodes:(BOOL)shouldHideThumbStickNodes
{
    _shouldHideThumbStickNodes = shouldHideThumbStickNodes;
    
    self.thumbStick.hidden = _shouldHideThumbStickNodes;
    self.actionButton.hidden = _shouldHideThumbStickNodes;
}

- (BOOL)isUserInteractionEnabled
{
    return YES;
}

- (void)thumbStickNode:(OGThumbStickNode *)node didUpdateXValue:(CGFloat)xValue yValue:(CGFloat)yValue
{
    if (node == self.thumbStick)
    {
        CGVector displacement = CGVectorMake(xValue, yValue);
        [self.inputSourceDelegate didUpdateDisplacement:displacement];
    }
}

- (void)actionButtonNode:(OGActionButtonNode *)node isPressed:(BOOL)pressed
{
    if (node == self.actionButton)
    {
        [self.inputSourceDelegate didPressed:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    for (UITouch *touch in touches)
    {
        CGPoint touchPoint = [touch locationInNode:self];
        
        BOOL touchIsInCenter = touchPoint.x < self.centerDividerWidth / 2.0 && touchPoint.x > -self.centerDividerWidth / 2.0;
        
        if (touchIsInCenter || self.shouldHideThumbStickNodes)
        {
            continue;
        }
        
        NSSet *set = [NSSet setWithObject:touch];
        if (touchPoint.x < 0.0)
        {
            [self.controlTouches unionSet:set];
            self.thumbStick.position = [self pointByCheckingControlOffset:touchPoint];
            [self.thumbStick touchesBegan:set withEvent:event];
            
        }
        else
        {
            [self.actionButtonTouches unionSet:set];
            self.actionButton.position = [self pointByCheckingControlOffset:touchPoint];
            [self.actionButton touchesBegan:set withEvent:event];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    for (UITouch *touch in touches)
    {
        CGPoint touchPoint = [touch locationInNode:self];
        
        if (touchPoint.x < 0.0)
        {
            NSMutableSet *movedLeftTouches = [NSMutableSet setWithSet:touches];
            [movedLeftTouches intersectSet:self.controlTouches];
            [self.thumbStick touchesMoved:movedLeftTouches withEvent:event];
        }
        else
        {
            NSMutableSet *movedRightTouches = [NSMutableSet setWithSet:touches];
            [movedRightTouches intersectSet:self.actionButtonTouches];
            [self.actionButton touchesMoved:movedRightTouches withEvent:event];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
   
    for (UITouch *touch in touches)
    {
        CGPoint touchPoint = [touch locationInNode:self];
        
        if (touchPoint.x < 0.0)
        {
            NSMutableSet *endedLeftTouches = [NSMutableSet setWithObject:touches];
            [endedLeftTouches intersectSet:self.controlTouches];
            [self.thumbStick touchesEnded:endedLeftTouches withEvent:event];
            [self.controlTouches minusSet:endedLeftTouches];
        }
        else
        {
            NSMutableSet *endedRightTouches = [NSMutableSet setWithObject:touches];
            [endedRightTouches intersectSet:self.actionButtonTouches];
            [self.actionButton touchesEnded:endedRightTouches withEvent:event];
            [self.actionButtonTouches minusSet:endedRightTouches];
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    [self.thumbStick resetTouchPad];
    [self.actionButton resetButton];
    
    [self.controlTouches removeAllObjects];
    [self.actionButtonTouches removeAllObjects];
}

- (CGPoint)pointByCheckingControlOffset:(CGPoint)suggestedPoint
{
    CGSize controlSize = self.thumbStick.size;
    CGSize sceneSize = self.scene.size;
    
    CGFloat minX = -sceneSize.width / 2 + controlSize.width / 1.5;
    CGFloat maxX = sceneSize.width / 2 - controlSize.width / 1.5;
    
    CGFloat minY = -sceneSize.height / 2 + controlSize.height / 1.5;
    CGFloat maxY = sceneSize.height / 2 - controlSize.height / 1.5;
    
    CGFloat boundX = MAX(MIN(suggestedPoint.x, maxX), minX);
    CGFloat boundY = MAX(MIN(suggestedPoint.y, maxY), minY);
    
    return CGPointMake(boundX, boundY);
}

@end
