//
//  OGSettingsScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSettingsScene.h"
#import "OGGameScene.h"
#import "SKColor+OGConstantColors.h"

NSString *const kOGSettingsSceneTapButton = @"tapButton";
NSString *const kOGSettingsSceneSwipeButton = @"swipeButton";

@implementation OGSettingsScene

- (void)didMoveToView:(SKView *)view
{
    self.backgroundColor = [SKColor backgroundLightGrayColor];
    
    [self tapButtonNode];
    [self swipeButtonNode];
}

- (void)tapButtonNode //0
{
    SKLabelNode *tapButton = [SKLabelNode labelNodeWithText:@"Tap"];
    
    tapButton.name = kOGSettingsSceneTapButton;
    tapButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 50);
    tapButton.fontColor = [SKColor gameBlue];
    tapButton.fontName = @"Helvetica";
    
    [self addChild:tapButton];
}

- (void)swipeButtonNode //1
{
    SKLabelNode *swipeButton = [SKLabelNode labelNodeWithText:@"Swipe"];
    
    swipeButton.name = kOGSettingsSceneSwipeButton;
    swipeButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50);
    swipeButton.fontColor = [SKColor gameBlue];
    swipeButton.fontName = @"Helvetica";
    
    [self addChild:swipeButton];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node isKindOfClass:[SKLabelNode class]])
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        NSMutableDictionary *plistdict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];

        if ([node.name isEqualToString:kOGSettingsSceneTapButton])
        {
            [plistdict setValue:@(0) forKey:@"Current Control Type"];
        }
        else if ([node.name isEqualToString:kOGSettingsSceneSwipeButton])
        {
            [plistdict setValue:@(1) forKey:@"Current Control Type"];
        }
        
        [plistdict writeToFile:filePath atomically:YES];
        
        OGGameScene *nextScene = [[OGGameScene alloc] initWithSize:self.frame.size];
        nextScene.controlType = node.name;
        [self.view presentScene:nextScene];
        [nextScene release];
    }
}

@end
