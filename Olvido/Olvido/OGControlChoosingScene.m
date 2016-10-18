//
//  OGControlChoosingScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/18/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGControlChoosingScene.h"
#import "OGGameViewController.h"

@implementation OGControlChoosingScene

- (void)didMoveToView:(SKView *)view
{
    CGFloat offset = 50.0;
    
    self.backgroundColor = [SKColor whiteColor];
    
    SKLabelNode *tapButton = [self createButtonWithTitle:@"Tap" atPoint:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + offset)];
    SKLabelNode *dragButton = [self createButtonWithTitle:@"Drag" atPoint:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - offset)];
    
    [self addChild:tapButton];
    [self addChild:dragButton];
}

- (SKLabelNode *)createButtonWithTitle:(NSString *)title atPoint:(CGPoint)point
{
    SKLabelNode *button = [SKLabelNode labelNodeWithText:title];
    
    button.name = title;
    button.position = point;
    button.fontSize = 48.0;
    button.fontColor = [SKColor blueColor];
    
    return button;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:location];
    
    if ([touchedNode.name isEqualToString:@"Tap"])
    {
        self.viewController.controlType = @"Tap";
        
        [self.viewController startGame];
    }
    else if ([touchedNode.name isEqualToString:@"Drag"])
    {
        self.viewController.controlType = @"Drag";
        
        [self.viewController startGame];
    }
}

@end
