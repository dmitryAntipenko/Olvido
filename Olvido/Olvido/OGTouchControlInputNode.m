//
//  OGTouchControlInputNode.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTouchControlInputNode.h"
#import "OGThumbStickNode.h"
#import "OGButtonNode.h"

NSString *const OGTouchControlInputNodePauseButtonTexture = @"MenuButton";
NSString *const OGTouchControlInputNodePauseButtonTouchedColor = @"0xd3d3d3";
NSString *const OGTouchControlInputNodePayseButtonName = @"PauseButton";;

@interface OGTouchControlInputNode () <OGThumbStickNodeDelegate>

@property (nonatomic, strong) OGThumbStickNode *leftThumbStick;
@property (nonatomic, strong) OGThumbStickNode *rightThumbStick;

@property (nonatomic, strong) OGButtonNode *pauseNode;

@property (nonatomic, strong) NSMutableSet<UITouch *> *leftControlTouches;
@property (nonatomic, strong) NSMutableSet<UITouch *> *rightControlTouches;

@property (nonatomic, assign) CGFloat centerDividerWidth;

@end

@implementation OGTouchControlInputNode

- (instancetype)initWithFrame:(CGRect)frame thumbStickNodeSize:(CGSize)size
{
    self = [super initWithTexture:nil color:[SKColor clearColor] size:size];
    
    if (self)
    {
        _centerDividerWidth = frame.size.width / 4.5;
        
        CGFloat halfFrameWidth = frame.size.width / 2.0;
        CGFloat halfFrameHeight = frame.size.height / 2.0;
        
        CGFloat initialVerticalOffset = -size.height;
        CGFloat initialHorizontalOffset = halfFrameWidth - size.width;
        
        _leftControlTouches = [NSMutableSet set];
        _rightControlTouches = [NSMutableSet set];
        
        _leftThumbStick = [[OGThumbStickNode alloc] initWithSize:size];
        _leftThumbStick.position = CGPointMake(-initialHorizontalOffset, initialVerticalOffset);
        
        _rightThumbStick = [[OGThumbStickNode alloc] initWithSize:size];
        _rightThumbStick.position = CGPointMake(initialHorizontalOffset, initialVerticalOffset);
        
        _rightThumbStick.thumbStickNodeDelegate = self;
        _leftThumbStick.thumbStickNodeDelegate = self;
        
        _pauseNode = [[OGButtonNode alloc] init];
        _pauseNode.name = OGTouchControlInputNodePayseButtonName;
        _pauseNode.texture = [SKTexture textureWithImageNamed:OGTouchControlInputNodePauseButtonTexture];
        _pauseNode.size = CGSizeMake(75, 75);
        _pauseNode.position = CGPointMake(halfFrameWidth - _pauseNode.size.width,
                                          halfFrameHeight - _pauseNode.size.height);
        _pauseNode.colorBlendFactor = 1.0;
        _pauseNode.color = [SKColor whiteColor];
        
        NSMutableDictionary *userData = [NSMutableDictionary dictionary];
        userData[OGButtonNodeUserDataTouchedColorKey] = OGTouchControlInputNodePauseButtonTouchedColor;
        _pauseNode.userData = userData;
        
        [self addChild:_leftThumbStick];
        [self addChild:_rightThumbStick];
        [self addChild:_pauseNode];
    }
    
    return self;
}

- (void)setShouldHideThumbStickNodes:(BOOL)shouldHideThumbStickNodes
{
    _shouldHideThumbStickNodes = shouldHideThumbStickNodes;
    
    self.leftThumbStick.hidden = _shouldHideThumbStickNodes;
    self.rightThumbStick.hidden = _shouldHideThumbStickNodes;
}

- (void)setShouldHidePauseNode:(BOOL)shouldHidePauseNode
{
    _shouldHidePauseNode = shouldHidePauseNode;
    
    self.pauseNode.hidden = _shouldHidePauseNode;
}

- (BOOL)isUserInteractionEnabled
{
    return YES;
}

- (void)thumbStickNode:(SKSpriteNode *)node isPressed:(BOOL)pressed
{
    if (node == self.rightThumbStick)
    {
        [self.inputSourceDelegate didPressed:pressed];
    }
}

- (void)thumbStickNode:(OGThumbStickNode *)node didUpdateXValue:(CGFloat)xValue yValue:(CGFloat)yValue
{
    CGVector displacement = CGVectorMake(xValue, yValue);
    
    if (node == self.leftThumbStick)
    {
        [self.inputSourceDelegate didUpdateDisplacement:displacement];
    }
    else
    {
        [self.inputSourceDelegate didUpdateAttackDisplacement:displacement];
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
//            [self]
        }
        
        NSSet *set = [NSSet setWithObject:touch];
        if (touchPoint.x < 0.0 && self.leftControlTouches.count == 0)
        {
            [self.leftControlTouches unionSet:set];
            self.leftThumbStick.position = [self pointByCheckingControlOffset:touchPoint];
            [self.leftThumbStick touchesBegan:set withEvent:event];            
        }
        else if (touchPoint.x > 0.0 && self.rightControlTouches.count == 0)
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
   
    NSMutableSet *endedLeftTouches = [NSMutableSet setWithSet:touches];
    [endedLeftTouches intersectSet:self.leftControlTouches];
    [self.leftThumbStick touchesEnded:endedLeftTouches withEvent:event];
    [self.leftControlTouches minusSet:endedLeftTouches];

    NSMutableSet *endedRightTouches = [NSMutableSet setWithSet:touches];
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
