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

NSString *const kOGGameSceneTimerCircleNodeName = @"timerCircleNode";
NSString *const kOGGameSceneBorderNodeName = @"borderNode";
NSString *const kOGGameSceneBorderCropNodeName = @"borderCropNode";

NSString *const kOGGameSceneTimerCircleTextureName = @"TimerCircle";

@interface OGGameScene ()

@property (nonatomic, assign, readonly) CGFloat scaleFactor;

@end

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
    
    timerNode.fontSize = kOGTimerNodeFontDefaultSize * self.scaleFactor;
    
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
    
    gameOverScreen.alpha = 0.0;
    
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
    
    scoreLabel.fontSize = kOGGameSceneScoreDefaultFontSize * self.scaleFactor;
    scoreLabel.fontColor = [SKColor gameBlack];
    
    return scoreLabel;
}

- (SKSpriteNode *)createTimerCircleWithColor:(SKColor *)color inPoint:(CGPoint)point
{
    SKTexture *timerCircleTexture = [SKTexture textureWithImageNamed:kOGGameSceneTimerCircleTextureName];
    CGFloat timerCircleRadius = self.frame.size.width / kOGGameSceneTimerCircleRadiusFactor;
    
    SKSpriteNode *timerCircle = [SKSpriteNode spriteNodeWithTexture:timerCircleTexture
                                                               size:CGSizeMake(timerCircleRadius * 2.0,
                                                                               timerCircleRadius * 2.0)];
    timerCircle.name = kOGGameSceneTimerCircleNodeName;
    timerCircle.color = color;
    timerCircle.colorBlendFactor = 1.0;
    timerCircle.position = point;
    
    return timerCircle;
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
