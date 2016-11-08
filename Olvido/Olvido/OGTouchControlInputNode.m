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

@interface OGTouchControlInputNode () <OGThumbStickNodeDelegate>

@property (nonatomic, strong) OGThumbStickNode *leftThumbStick;
@property (nonatomic, strong) OGThumbStickNode *rightThumbStick;

@property (nonatomic, strong) NSMutableSet<UITouch *> *leftControlTouches;
@property (nonatomic, strong) NSMutableSet<UITouch *> *rightControlTouches;

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
        
        _leftControlTouches = [NSMutableSet set];
        _rightControlTouches = [NSMutableSet set];
        
        _leftThumbStick = [[OGThumbStickNode alloc] initWithSize:size];
        _leftThumbStick.position = CGPointMake(-initialHorizontalOffset, initialVerticalOffset);
        
        _rightThumbStick = [[OGThumbStickNode alloc] initWithSize:size];
        _rightThumbStick.position = CGPointMake(initialHorizontalOffset, initialVerticalOffset);
        
        _rightThumbStick.thumbStickNodeDelegate = self;
        _leftThumbStick.thumbStickNodeDelegate = self;
        
        [self addChild:_leftThumbStick];
        [self addChild:_rightThumbStick];
    }
    
    return self;
}

- (void)setShouldHideThumbStickNodes:(BOOL)shouldHideThumbStickNodes
{
    _shouldHideThumbStickNodes = shouldHideThumbStickNodes;
    
    self.leftThumbStick.hidden = _shouldHideThumbStickNodes;
    self.rightThumbStick.hidden = _shouldHideThumbStickNodes;
}

- (BOOL)isUserInteractionEnabled
{
    return YES;
}

- (void)thumbStickNode:(OGThumbStickNode *)node didUpdateXValue:(CGFloat)xValue yValue:(CGFloat)yValue
{
    if (node == self.leftThumbStick)
    {
        CGVector displacement = CGVectorMake(xValue, yValue);
        [self.inputSourceDelegate didUpdateDisplacement:displacement];
    }
    else if (node == self.rightThumbStick)
    {
        // do something
    }
}

- (void)thumbStickNode:(OGThumbStickNode *)node isPressed:(BOOL)pressed
{
    // do something
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
            [self.leftControlTouches unionSet:set];
            self.leftThumbStick.position = [self pointByCheckingControlOffset:touchPoint];
            [self.leftThumbStick touchesBegan:set withEvent:event];
            
        }
        else
        {
            [self.rightControlTouches unionSet:set];
            self.rightThumbStick.position = [self pointByCheckingControlOffset:touchPoint];
            [self.rightThumbStick touchesBegan:set withEvent:event];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    NSMutableSet *movedLeftTouches = [NSMutableSet setWithSet:touches];
    [movedLeftTouches intersectSet:self.leftControlTouches];
    [self.leftThumbStick touchesMoved:movedLeftTouches withEvent:event];
    
    NSMutableSet *movedRightTouches = [NSMutableSet setWithSet:touches];
    [movedRightTouches intersectSet:self.rightControlTouches];
    [self.rightThumbStick touchesMoved:movedRightTouches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    NSMutableSet *endedLeftTouches = [NSMutableSet setWithObject:touches];
    [endedLeftTouches intersectSet:self.leftControlTouches];
    [self.leftThumbStick touchesEnded:endedLeftTouches withEvent:event];
    [self.leftControlTouches minusSet:endedLeftTouches];

    NSMutableSet *endedRightTouches = [NSMutableSet setWithObject:touches];
    [endedRightTouches intersectSet:self.rightControlTouches];
    [self.rightThumbStick touchesEnded:endedRightTouches withEvent:event];
    [self.rightControlTouches minusSet:endedRightTouches];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    [self.leftThumbStick resetTouchPad];
    [self.rightThumbStick resetTouchPad];
    
    [self.leftControlTouches removeAllObjects];
    [self.rightControlTouches removeAllObjects];
}

- (CGPoint)pointByCheckingControlOffset:(CGPoint)suggestedPoint
{
    CGSize controlSize = self.leftThumbStick.size;
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
