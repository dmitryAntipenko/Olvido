//
//  OGGameScene+OGGameSceneCreation.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene+OGGameSceneCreation.h"
#import "SKColor+OGConstantColors.h"

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
    
    SKLabelNode *timerOutput = [SKLabelNode node];
    timerOutput.text = @"Test";
    timerOutput.fontColor = [SKColor backgroundGrayColor];
    timerOutput.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    timerOutput.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    timerOutput.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    [middleground addChild:timerOutput];
    
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
    
    timerCircle.path = CGPathCreateWithEllipseInRect(CGRectMake(point.x - kOGGameSceneTimerCircleRadius,
                                                                point.y - kOGGameSceneTimerCircleRadius,
                                                                kOGGameSceneTimerCircleRadius * 2.0,
                                                                kOGGameSceneTimerCircleRadius * 2.0), nil);
    timerCircle.strokeColor = color;
    timerCircle.lineWidth = kOGGameSceneTimerCircleLineWidth;
    timerCircle.antialiased = YES;
    
    return timerCircle;
}

- (SKShapeNode *)createBackgroundBorderWithColor:(SKColor *)color
{
    SKShapeNode *border = [SKShapeNode node];
    
    border.path = CGPathCreateWithRect(self.frame, nil);
    border.strokeColor = color;
    border.lineWidth = pow(kOGGameSceneBorderSize, 2);
    
    return border;
}

@end
