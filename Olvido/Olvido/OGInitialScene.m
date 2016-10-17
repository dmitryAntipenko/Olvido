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
    SKNode *nodeA = contact.bodyA.node;
    SKNode *nodeB = contact.bodyB.node;
    
    if ([nodeA.name isEqualToString:kOGPortalNodeName] && [nodeB.name isEqualToString:kOGPlayerNodeName])
    {
        OGEntity *portal = (OGEntity *)((OGSpriteNode *) nodeA).owner.entity;
        OGTransitionComponent *transitionComponent = (OGTransitionComponent *) [portal componentForClass:[OGTransitionComponent class]];
        transitionComponent.closed = NO;
        
        [self.sceneDelegate gameSceneDidCallFinishWithPortal:portal];
    }
    else if ([nodeB.name isEqualToString:kOGPortalNodeName] && [nodeA.name isEqualToString:kOGPlayerNodeName])
    {
        OGEntity *portal = (OGEntity *)((OGSpriteNode *) nodeB).owner.entity;
        OGTransitionComponent *transitionComponent = (OGTransitionComponent *) [portal componentForClass:[OGTransitionComponent class]];
        transitionComponent.closed = NO;
        
        [self.sceneDelegate gameSceneDidCallFinishWithPortal:portal];
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
