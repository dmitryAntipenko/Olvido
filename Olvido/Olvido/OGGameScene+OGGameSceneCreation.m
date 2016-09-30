//
//  OGGameScene+OGGameSceneCreation.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene+OGGameSceneCreation.h"
#import "SKColor+OGConstantColors.h"

NSUInteger const kOGGameSceneBorderSize = 3;
NSUInteger const kOGGameSceneTimerCircleRadius = 100;

@implementation OGGameScene (OGGameSceneCreation)

- (SKNode *)createBackground
{
    SKNode *background = [SKNode node];
    SKColor *accentColor = [SKColor backgroundGrayColor];
    [background addChild:[self createBackgroundBorderWithColor:accentColor]];
    
    return background;
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
                                                                kOGGameSceneTimerCircleRadius * 2,
                                                                kOGGameSceneTimerCircleRadius * 2), nil);
    timerCircle.strokeColor = color;
    timerCircle.lineWidth = 5.0;
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
