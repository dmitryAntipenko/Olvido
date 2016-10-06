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

CGFloat const kOGGameSceneScoreDefaultFontSize = 36.0;
CGFloat const kOGGameSceneBorderSize = 3.0;

CGFloat const kOGGameSceneTimerCircleRadiusFactor = 4.0;
CGFloat const kOGGameSceneTimerCircleLineWidth = 5.0;
CGFloat const kOGGameSceneTimerCircleRadius = 100.0;
CGFloat const kOGGameSceneTimerLabelScaleFactor = 500.0;

CGFloat const kOGGameSceneButtonsMargin = 20.0;
CGFloat const kOGGameSceneButtonsVerticalMargin = 40.0;
CGFloat const kOGGameSceneButtonWidth = 80.0;

CGFloat const kOGGameSceneGameOverScreenHeightFactor = 2.5;
CGFloat const kOGGameSceneGameOverButtonPositionFactor = 4.0;

NSString *const kOGGameSceneGameOverBackgroundSpriteName = @"GameOverBackground";
NSString *const kOGGameSceneMenuButtonSpriteName = @"MenuButton";
NSString *const kOGGameSceneRestartButtonSpriteName = @"RestartButton";

@implementation OGGameScene (OGGameSceneCreation)

#pragma - mark Top Game Scene Nodes

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
    
    timerNode.fontSize = kOGTimerNodeFontDefaultSize * [self scaleFactor];
    
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

- (SKNode *)createGameOverScreenWithScore:(NSNumber *)score
{
    SKTexture *gameOverBackground = [SKTexture textureWithImageNamed:kOGGameSceneGameOverBackgroundSpriteName];
    SKSpriteNode *gameOverScreen = [SKSpriteNode spriteNodeWithTexture:gameOverBackground];
    
    gameOverScreen.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    gameOverScreen.size = CGSizeMake(self.frame.size.width,
                                     self.frame.size.height / kOGGameSceneGameOverScreenHeightFactor);
    
    SKLabelNode *scoreNode = [self createScoreLaberWithScore:score];
    [gameOverScreen addChild:scoreNode];

    CGPoint menuButtonPosition = CGPointMake(-gameOverScreen.size.width / kOGGameSceneGameOverButtonPositionFactor,
                                             -gameOverScreen.size.height / kOGGameSceneGameOverButtonPositionFactor);
    
    CGPoint restartButtonPosition = CGPointMake(gameOverScreen.size.width / kOGGameSceneGameOverButtonPositionFactor,
                                                -gameOverScreen.size.height / kOGGameSceneGameOverButtonPositionFactor);
    
    [gameOverScreen addChild:[self createButtonWithImageNamed:kOGGameSceneMenuButtonSpriteName
                                                      atPoint:menuButtonPosition]];
    
    [gameOverScreen addChild:[self createButtonWithImageNamed:kOGGameSceneRestartButtonSpriteName
                                                      atPoint:restartButtonPosition]];
    
    return gameOverScreen;
}

#pragma - mark Subitems

- (SKLabelNode *)createScoreLaberWithScore:(NSNumber *)score
{
    NSString *scoreString = [[NSString alloc] initWithFormat:@"Your Score %@", score];
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithText:scoreString];
    [scoreString release];
    
    scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    
    scoreLabel.fontSize = kOGGameSceneScoreDefaultFontSize * [self scaleFactor];
    scoreLabel.fontColor = [SKColor gameBlack];
    
    return scoreLabel;
}

- (SKCropNode *)createTimerCircleWithColor:(SKColor *)color inPoint:(CGPoint)point
{
    CGFloat timerCircleRadius = self.frame.size.width / kOGGameSceneTimerCircleRadiusFactor;
    SKSpriteNode *timerCircle = [SKSpriteNode spriteNodeWithColor:color
                                                             size:CGSizeMake(timerCircleRadius * 2.0, timerCircleRadius * 2.0)];
    
    timerCircle.position = point;
    
    CGRect maskRect = CGRectMake(point.x - timerCircleRadius + kOGGameSceneTimerCircleLineWidth,
                                 point.y - timerCircleRadius + kOGGameSceneTimerCircleLineWidth,
                                 2.0 * (timerCircleRadius - kOGGameSceneTimerCircleLineWidth),
                                 2.0 * (timerCircleRadius - kOGGameSceneTimerCircleLineWidth));
    
    CGPathRef path = CGPathCreateWithEllipseInRect(maskRect, nil);
    SKShapeNode *mask = [SKShapeNode shapeNodeWithPath:path];
    mask.lineWidth = kOGGameSceneTimerCircleLineWidth;
    mask.strokeColor = color;
    
    SKCropNode *crop = [SKCropNode node];
    crop.maskNode = mask;
    [crop addChild:timerCircle];
    
    CGPathRelease(path);

    return crop;
}

- (SKCropNode *)createBackgroundBorderWithColor:(SKColor *)color
{
    SKSpriteNode *border = [SKSpriteNode spriteNodeWithColor:color
                                                        size:self.frame.size];
    
    border.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    CGPathRef path = CGPathCreateWithRect(self.frame, nil);
    SKShapeNode *mask = [SKShapeNode shapeNodeWithPath:path];
    mask.lineWidth = pow(kOGGameSceneBorderSize, 2);
    mask.strokeColor = color;
    
    SKCropNode *crop = [SKCropNode node];
    crop.maskNode = mask;
    [crop addChild:border];
    
    CGPathRelease(path);
    
    return crop;
}

- (SKNode *)createDimPanel
{
    SKSpriteNode *dimPanel = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:self.frame.size];
    
    dimPanel.alpha = 0.0;
    
    CGPoint position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    dimPanel.position = position;
    
    return dimPanel;
}

- (SKSpriteNode *)createButtonWithImageNamed:(NSString *)name atPoint:(CGPoint)point
{
    SKSpriteNode *button = [SKSpriteNode spriteNodeWithImageNamed:name];
    
    button.name = name;
    button.position = point;
    button.size = CGSizeMake(kOGGameSceneButtonWidth, kOGGameSceneButtonWidth);
    
    return button;
}

- (CGFloat)scaleFactor
{
    return self.frame.size.width / kOGGameSceneTimerLabelScaleFactor;
}

@end
