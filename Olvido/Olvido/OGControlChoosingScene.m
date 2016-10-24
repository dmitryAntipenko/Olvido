//
//  OGControlChoosingScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/18/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGControlChoosingScene.h"
#import "OGGameViewController.h"
#import "OGMainMenuState.h"

NSString *const kOGControlChoosingSceneFormat = @"GOD MODE: %@";

@interface OGControlChoosingScene ()

@property (nonatomic, assign) BOOL godMode;
@property (nonatomic, retain) SKLabelNode *godModeLabel;
@property (nonatomic, retain) SKSpriteNode *jesus;

@end

@implementation OGControlChoosingScene

- (void)didMoveToView:(SKView *)view
{
    CGFloat offset = 100.0;
    
    self.jesus = [SKSpriteNode spriteNodeWithImageNamed:@"Jesus"];
    self.jesus.alpha = 0.0;
    self.jesus.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.jesus.size = self.frame.size;
    
    self.backgroundColor = [SKColor blackColor];
    
    SKLabelNode *tapButton = [self createButtonWithTitle:@"Tap" atPoint:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + offset)];
    SKLabelNode *dragButton = [self createButtonWithTitle:@"Drag" atPoint:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    SKLabelNode *godMode = [self createButtonWithTitle:@"godMode" atPoint:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - offset)];
    
    godMode.text = @"GOD MODE: OFF";
    
    self.godModeLabel = godMode;
    
    [self addChild:self.jesus];
    [self addChild:tapButton];
    [self addChild:dragButton];
    [self addChild:godMode];
}

- (SKLabelNode *)createButtonWithTitle:(NSString *)title atPoint:(CGPoint)point
{
    SKLabelNode *button = [SKLabelNode labelNodeWithText:title];
    
    button.name = title;
    button.position = point;
    button.fontSize = 32.0;
    button.fontName = @"Helvetica";
    button.fontColor = [SKColor whiteColor];
    
    return button;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:location];
    
    if ([touchedNode.name isEqualToString:@"Tap"])
    {
        [((OGMainMenuState *) self.uiStateMachine.currentState) startGameWithControlType:touchedNode.name godMode:self.godMode];
    }
    else if ([touchedNode.name isEqualToString:@"Drag"])
    {
        [((OGMainMenuState *) self.uiStateMachine.currentState) startGameWithControlType:touchedNode.name godMode:self.godMode];
    }
    else if ([touchedNode.name isEqualToString:@"godMode"])
    {
        self.godMode = !self.godMode;
        
        if (self.godMode)
        {
            self.jesus.alpha = 1.0;
        }
        else
        {
            self.jesus.alpha = 0.0;
        }
        
        self.godModeLabel.text = [NSString stringWithFormat:kOGControlChoosingSceneFormat, (self.godMode) ? @"ON" : @"OFF"];
    }
}

- (void)dealloc
{
    [_uiStateMachine release];
    [_godModeLabel release];
    [_jesus release];
    
    [super dealloc];
}

@end
