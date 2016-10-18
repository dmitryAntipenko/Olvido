//
//  OGDarkScene.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/18/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDarkScene.h"
#import "OGGameScene+OGGameSceneCreation.h"
#import "OGTorchComponent.h"

NSInteger const kOGDarkSceneDarknessRadius = 200;

@implementation OGDarkScene

- (void)createSceneContents
{
    [super createSceneContents];
    
    self.backgroundColor = [SKColor gameGreen];
    
    [self addChild:[self createBackgroundBorderWithColor:[SKColor gameDarkRed]]];
    
    [self createEnemies];
    for (OGEntity *enemy in self.enemies)
    {
        ((OGVisualComponent *) [enemy componentForClass:[OGVisualComponent class]]).color = [SKColor gameWhite];
        ((OGVisualComponent *) [enemy componentForClass:[OGVisualComponent class]]).spriteNode.lightingBitMask = 1.0;
    }
    
    [self createPlayer];
    
    OGVisualComponent *visualComponent = (OGVisualComponent *)[self.player componentForClass:[OGVisualComponent class]];
    [self.player addComponent:[[OGTorchComponent alloc] initWithTorchSprite:visualComponent.spriteNode
                                                               tourchRadius:kOGDarkSceneDarknessRadius]];
    
    OGTorchComponent *torchComponent = (OGTorchComponent *)[self.player componentForClass:[OGTorchComponent class]];
    [torchComponent torchTurnOn];
    [torchComponent createDarknessWithSize:self.size];
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
    
    if ([nodeA.name isEqualToString:kOGPortalNodeName])
    {
        OGEntity *portal = (OGEntity *)((OGSpriteNode *) nodeA).owner.entity;
        OGTransitionComponent *transitionComponent = (OGTransitionComponent *) [portal componentForClass:[OGTransitionComponent class]];
        transitionComponent.closed = NO;
        [self.sceneDelegate gameSceneDidCallFinishWithPortal:portal];
    }
    else if ([nodeB.name isEqualToString:kOGPortalNodeName])
    {
        OGEntity *portal = (OGEntity *)((OGSpriteNode *) nodeB).owner.entity;
        OGTransitionComponent *transitionComponent = (OGTransitionComponent *) [portal componentForClass:[OGTransitionComponent class]];
        transitionComponent.closed = NO;
        [self.sceneDelegate gameSceneDidCallFinishWithPortal:portal];
    }
}

@end
