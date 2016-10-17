//
//  OGObstaclesScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGObstaclesScene.h"
#import "OGGameScene+OGGameSceneCreation.h"

CGFloat const kOGObstacleWidth = 30.0;

@implementation OGObstaclesScene

- (void)createSceneContents
{
    self.backgroundColor = [SKColor gameRed];
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = kOGCollisionBitMaskObstacle;
    self.physicsBody.collisionBitMask = kOGCollisionBitMaskPlayer | kOGCollisionBitMaskEnemy;
    self.physicsBody.contactTestBitMask = kOGCollisionBitMaskPlayer;
    
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    self.physicsWorld.contactDelegate = self;
    
    [self addChild:[self createBackgroundBorderWithColor:[SKColor gameDarkRed]]];
    
    [self createEnemies];
    [self createPlayer];
    
    [self createObstaclesWithSize:CGSizeMake(self.frameOffset * 2.0, kOGObstacleWidth)
                          atPoint:CGPointMake(CGRectGetMidX(self.frame), self.frameOffset)];
    
    [self createObstaclesWithSize:CGSizeMake(self.frameOffset * 2.0, kOGObstacleWidth)
                          atPoint:CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - self.frameOffset)];
}

- (CGFloat)frameOffset
{
    return self.frame.size.height / 5.0;
}

- (void)createObstaclesWithSize:(CGSize)size atPoint:(CGPoint)point
{
    OGEntity *obstacle = [OGEntity entity];
    
    OGVisualComponent *visualComponent = [[OGVisualComponent alloc] init];
    visualComponent.spriteNode = [OGSpriteNode spriteNodeWithImageNamed:kOGSceneControllerHorizontalPortalTextureName];
    visualComponent.color = [SKColor gameBlack];
    
    OGSpriteNode *sprite = visualComponent.spriteNode;
    sprite.owner = visualComponent;
    sprite.size = size;
    sprite.position = point;
    
    sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    
    sprite.physicsBody.categoryBitMask = kOGCollisionBitMaskObstacle;
    sprite.physicsBody.collisionBitMask = kOGCollisionBitMaskDefault;
    sprite.physicsBody.contactTestBitMask = kOGCollisionBitMaskDefault;
    
    [obstacle addComponent:visualComponent];
    
    [self addChild:sprite];
    
    [visualComponent release];
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
    
    //    NSLog(@" a : %@, B : %@", contact.bodyA.node.name, contact.bodyB.node.name);
}

- (void)dealloc
{
    [super dealloc];
}

@end
