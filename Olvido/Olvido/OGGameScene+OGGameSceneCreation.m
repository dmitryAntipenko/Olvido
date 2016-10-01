//
//  OGGameScene+OGGameSceneCreation.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene+OGGameSceneCreation.h"
#import "SKColor+OGConstantColors.h"
#import "OGTimerNode.h"

CGFloat const kOGGameSceneBorderSize = 3.0;
CGFloat const kOGGameSceneTimerCircleLineWidth = 5.0;
CGFloat const kOGGameSceneTimerCircleRadius = 100.0;

@implementation OGGameScene (OGGameSceneCreation)

- (SKNode *)createBackground
{
    SKNode *background = [SKNode node];
    SKColor *accentColor = [SKColor backgroundGrayColor];
    [background addChild:[self createBackgroundBorderWithColor:accentColor]];
    
    return background;
}

- (SKNode *)createMiddleGround
{
    SKNode *middleground = [SKNode node];
    
    OGTimerNode *timerNode = [[OGTimerNode alloc] initWithPoint:CGPointMake(CGRectGetMidX(self.frame),
                                                                            CGRectGetMidY(self.frame))];
    
    [middleground addChild:timerNode];
    
    [timerNode release];
    
    return middleground;
}

- (SKNode *)createForeground
{
    SKNode *foreground = [SKNode node];
    
    SKColor *accentColor = [SKColor backgroundGrayColor];
    CGPoint frameCenter = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [foreground addChild:[self createTimerCircleWithColor:accentColor inPoint:frameCenter]];
    
    return foreground;
}

- (SKShapeNode *)createTimerCircleWithColor:(SKColor *)color inPoint:(CGPoint)point
{
    SKShapeNode *timerCircle = [SKShapeNode node];
    
    CGPathRef path = CGPathCreateWithEllipseInRect(CGRectMake(point.x - kOGGameSceneTimerCircleRadius,
                                                              point.y - kOGGameSceneTimerCircleRadius,
                                                              kOGGameSceneTimerCircleRadius * 2.0,
                                                              kOGGameSceneTimerCircleRadius * 2.0), nil);
    
    timerCircle.path = path;
    timerCircle.strokeColor = color;
    timerCircle.lineWidth = kOGGameSceneTimerCircleLineWidth;
    timerCircle.antialiased = YES;
    
    CGPathRelease(path);
    
    return timerCircle;
}

- (SKShapeNode *)createBackgroundBorderWithColor:(SKColor *)color
{
    SKShapeNode *border = [SKShapeNode node];
    
    CGPathRef path = CGPathCreateWithRect(self.frame, nil);
    
    border.path = path;
    border.strokeColor = color;
    border.lineWidth = pow(kOGGameSceneBorderSize, 2);
    
    CGPathRelease(path);
    
    return border;
}

@end
