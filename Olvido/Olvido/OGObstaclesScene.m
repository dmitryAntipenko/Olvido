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
    [super createSceneContents];
    
    self.backgroundColor = [SKColor gameRed];
    
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
    [self.sceneDelegate gameSceneDidCallFinishWithPortal:self.portals[0]];
}

- (void)dealloc
{
    [super dealloc];
}

@end
