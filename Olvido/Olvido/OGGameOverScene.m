//
//  OGGameOverScene.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/19/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameOverScene.h"
#import "OGMainMenuState.h"

NSString *const kOGGameOverSceneGameOverText = @"Game Over!";
CGFloat const kOGGameOverSceneDefaultFontSize = 32.0;
NSString *const kOGGameOverSceneMenuImageName = @"MenuButton";
NSString *const kOGGameOverSceneRestartImageName = @"RestartButton";
NSString *const kOGGameOverSceneMenuName = @"Menu";
NSString *const kOGGameOverSceneRestartName = @"Restart";

@interface OGGameOverScene ()

@end

@implementation OGGameOverScene

- (void)didMoveToView:(SKView *)view
{
    SKLabelNode *gameOverLabel = [self createLabelWithTitle:kOGGameOverSceneGameOverText
                                                    atPoint:CGPointMake(150, 300)
                                                   fontSize:kOGGameOverSceneDefaultFontSize];
    
    SKLabelNode *scoreLabel = [self createLabelWithTitle:[NSString stringWithFormat:@"%@", self.score]
                                                 atPoint:CGPointMake(150, 250)
                                                fontSize:kOGGameOverSceneDefaultFontSize];
    
    SKSpriteNode *menuButton = [SKSpriteNode spriteNodeWithImageNamed:kOGGameOverSceneMenuImageName];
    menuButton.name = kOGGameOverSceneMenuName;
    menuButton.position = CGPointMake(100, 100);
    menuButton.size = CGSizeMake(100, 100);
    
    SKSpriteNode *restartButton = [SKSpriteNode spriteNodeWithImageNamed:kOGGameOverSceneRestartImageName];
    restartButton.name = kOGGameOverSceneRestartName;
    restartButton.position = CGPointMake(230, 100);
    restartButton.size = CGSizeMake(100, 100);
    
    [self addChild:gameOverLabel];
    [self addChild:scoreLabel];
    
    [self addChild:menuButton];
    [self addChild:restartButton];
}

- (SKLabelNode *)createLabelWithTitle:(NSString *)title atPoint:(CGPoint)point fontSize:(CGFloat)fontSize
{
    SKLabelNode *label = [SKLabelNode labelNodeWithText:title];
    
    label.name = title;
    label.position = point;
    label.fontSize = fontSize;
    label.fontName = @"Helvetica";
    label.fontColor = [SKColor whiteColor];
    
    return label;
}

- (void)dealloc
{
    [_uiStateMachine release];
    [_score release];
    
    [super dealloc];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:location];
    
    if ([touchedNode.name isEqualToString:kOGGameOverSceneMenuName])
    {
        if ([self.uiStateMachine canEnterState:[OGMainMenuState class]])
        {
            [self.uiStateMachine enterState:[OGMainMenuState class]];
        }
    }
    else if ([touchedNode.name isEqualToString:kOGGameOverSceneRestartName])
    {

        [((OGMainMenuState *) [self.uiStateMachine stateForClass:[OGMainMenuState class]]) startGameWithControlType:self.controlType
                                                                                                            godMode:self.godMode];
    }
}

@end
