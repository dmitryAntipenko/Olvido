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
#import "OGConstants.h"

@implementation OGGameScene (OGGameSceneCreation)

#pragma - mark Top Game Scene Nodes

- (SKNode *)createBackground
{
    SKNode *background = [SKNode node];
    SKColor *accentColor = [SKColor backgroundGrayColor];
    CGPoint frameCenter = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    [background addChild:[self createBackgroundBorderWithColor:accentColor]];
    [background addChild:[self createTimerCircleWithColor:accentColor inPoint:frameCenter]];
    
    background.zPosition = -2;
    
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
    
    middleground.zPosition = -1;
    
    return middleground;
}

- (SKNode *)createForeground
{
    SKNode *foreground = [SKNode node];
    
    
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
    
    timerCircle.name = kOGGameSceneTimerCircleNodeName;
    timerCircle.position = point;
    
    CGRect maskRect = CGRectMake(point.x - timerCircleRadius + kOGGameSceneTimerCircleLineWidth,
                                 point.y - timerCircleRadius + kOGGameSceneTimerCircleLineWidth,
                                 2.0 * (timerCircleRadius - kOGGameSceneTimerCircleLineWidth),
                                 2.0 * (timerCircleRadius - kOGGameSceneTimerCircleLineWidth));
    
    CGPathRef path = CGPathCreateWithEllipseInRect(maskRect, nil);
    SKShapeNode *mask = [SKShapeNode shapeNodeWithPath:path];
    mask.lineWidth = kOGGameSceneTimerCircleLineWidth;
    
    SKCropNode *crop = [SKCropNode node];
    crop.name = kOGGameSceneTimerCircleCropNodeName;
    crop.maskNode = mask;
    [crop addChild:timerCircle];
    
    CGPathRelease(path);

    return crop;
}

- (SKCropNode *)createBackgroundBorderWithColor:(SKColor *)color
{
    SKSpriteNode *border = [SKSpriteNode spriteNodeWithColor:color
                                                        size:self.frame.size];
    
    border.name = kOGGameSceneBorderNodeName;
    border.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    CGPathRef path = CGPathCreateWithRect(self.frame, nil);
    SKShapeNode *mask = [SKShapeNode shapeNodeWithPath:path];
    mask.lineWidth = pow(kOGGameSceneBorderSize, 2);
    
    SKCropNode *crop = [SKCropNode node];
    crop.name = kOGGameSceneBorderCropNodeName;
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
