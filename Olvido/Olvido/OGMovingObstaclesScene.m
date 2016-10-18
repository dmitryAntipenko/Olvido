//
//  OGMovingObstaclesScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMovingObstaclesScene.h"
#import "OGGameScene+OGGameSceneCreation.h"

CGFloat const kOGObstacleLinearDamping = 0.0;
CGFloat const kOGObstacleAngularDamping = 0.0;
CGFloat const kOGObstacleFriction = 0.0;
CGFloat const kOGObstacleRestitution = 1.0;

CGFloat const kOGObstacleMovementDuration = 1.0;

@implementation OGMovingObstaclesScene

- (void)createSceneContents
{
    [super createSceneContents];
    
    self.backgroundColor = [SKColor gameGreen];
    
    [self addChild:[self createBackgroundBorderWithColor:[SKColor gameDarkGreen]]];
    
    [self createEnemies];
    [self createPlayer];
    
    [self createObstaclesWithSize:CGSizeMake(self.frameOffset, 30.0)
                          atPoint:CGPointMake(CGRectGetMidX(self.frame), self.frameOffset)];
    
    [self createObstaclesWithSize:CGSizeMake(self.frameOffset, 30.0)
                          atPoint:CGPointMake(CGRectGetMidX(self.frame),
                                              self.frame.size.height - self.frameOffset)];

}

- (void)createObstaclesWithSize:(CGSize)size atPoint:(CGPoint)point
{
    OGEntity *obstacle = [OGEntity entity];
    
    OGVisualComponent *visualComponent = [[OGVisualComponent alloc] init];
    visualComponent.spriteNode = [OGSpriteNode spriteNodeWithImageNamed:kOGHorizontalPortalTextureName];
    visualComponent.color = [SKColor gameBlack];
    
    OGSpriteNode *sprite = visualComponent.spriteNode;
    sprite.owner = visualComponent;
    sprite.size = size;
    sprite.position = point;
    
    sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    sprite.physicsBody.restitution = kOGObstacleRestitution;
    sprite.physicsBody.friction = kOGObstacleFriction;
    sprite.physicsBody.linearDamping = kOGObstacleLinearDamping;
    sprite.physicsBody.angularDamping = kOGObstacleAngularDamping;
    
    sprite.physicsBody.categoryBitMask = kOGCollisionBitMaskObstacle;
    sprite.physicsBody.collisionBitMask = kOGCollisionBitMaskDefault;
    sprite.physicsBody.contactTestBitMask = kOGCollisionBitMaskDefault;
    
    [obstacle addComponent:visualComponent];
    
    [self addChild:sprite];
    
    SKAction *moveActionRight = [SKAction moveToX:self.frameOffset
                                         duration:kOGObstacleMovementDuration];
    
    SKAction *moveActionLeft = [SKAction moveToX:self.frame.size.width - self.frameOffset
                                        duration:kOGObstacleMovementDuration];
    
    SKAction *repeatAction = [SKAction repeatActionForever:[SKAction sequence:@[
                                                                                moveActionRight,
                                                                                moveActionLeft
                                                                                ]]];
    [sprite runAction:repeatAction];
    
    [visualComponent release];
}

- (CGFloat)frameOffset
{
    return self.frame.size.height / 5.0;
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
