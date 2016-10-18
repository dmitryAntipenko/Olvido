//
//  OGInitialScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGInitialScene.h"
#import "OGGameScene+OGGameSceneCreation.h"
#import "OGTapMovementControlComponent.h"

NSUInteger const kOGInitialSceneEnemiesCount = 4;

@implementation OGInitialScene

- (void)createSceneContents
{
    [super createSceneContents];
    
    self.backgroundColor = [SKColor backgroundLightGrayColor];
    
    [self addChild:[self createBackgroundBorderWithColor:[SKColor backgroundGrayColor]]];
    
    [self createEnemies];
    [self createPlayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    
    [self.playerMovementControlComponent touchBeganAtPoint:touchLocation];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    
    [self.playerMovementControlComponent touchMovedToPoint:touchLocation];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    
    [self.playerMovementControlComponent touchEndedAtPoint:touchLocation];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    [super didBeginContact:contact];
}

- (void)dealloc
{
    [super dealloc];
}

@end
