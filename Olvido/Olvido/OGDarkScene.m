//
//  OGDarkScene.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/18/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDarkScene.h"
#import "OGGameScene+OGGameSceneCreation.h"
#import "OGVisualComponent.h"

NSInteger const kOGDarkSceneDarknessRadius = 200;

@implementation OGDarkScene


- (void)createSceneContents
{
    [super createSceneContents];
    
    self.backgroundColor = [SKColor gameRed];
    
    
//     [self addChild:[self createBackgroundBorderWithColor:[SKColor gameDarkRed]]];
//    
//    
//    [self createEnemies];
//    for (OGEntity *enemy in self.enemies)
//    {
//        ((OGVisualComponent *) [enemy componentForClass:[OGVisualComponent class]]).color = [SKColor gameWhite];
////        ((OGVisualComponent *) [enemy componentForClass:[OGVisualComponent class]]).spriteNode.shadowedBitMask = 1;
////        ((OGVisualComponent *) [enemy componentForClass:[OGVisualComponent class]]).spriteNode.lightingBitMask = 1;
//    }
    [self createPlayer];
    OGVisualComponent *visualComponent = (OGVisualComponent *)[self.player componentForClass:[OGVisualComponent class]];
//    visualComponent.spriteNode.zPosition = 2;
//    visualComponent.color = [SKColor gameWhite];
//    
//    
//    SKCropNode *cropNode = [SKCropNode node];
//    SKSpriteNode *mask = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(100, 100)];
//    mask.position = visualComponent.spriteNode.position;
//    cropNode.zPosition=2;
//    //[cropNode addChild:((OGVisualComponent *) [self.player componentForClass:[OGVisualComponent class]]).spriteNode];
//    //[cropNode addChild:visualComponent.spriteNode];
//    [cropNode addChild:background];
//    cropNode.maskNode = visualComponent.spriteNode;
//    
//    //cropNode.position = CGPointMake(self.size.width/2, self.size.height/2);
//    
//    [self addChild:cropNode];
    CGFloat screenDiagonal = powf(powf(self.size.height, 2.0) + powf(self.size.width, 2.0), 0.5) + kOGDarkSceneDarknessRadius;
    SKShapeNode *darknessBackground = [SKShapeNode shapeNodeWithEllipseOfSize:CGSizeMake(screenDiagonal, screenDiagonal)];
    darknessBackground.strokeColor = [SKColor blackColor];
    darknessBackground.zPosition = 1;
    darknessBackground.lineWidth = screenDiagonal - (CGFloat)kOGDarkSceneDarknessRadius;
    //darknessBackground.lineLength = 500;
    
    [visualComponent.spriteNode addChild:darknessBackground];
    [self addChild:visualComponent.spriteNode];
    
//    SKSpriteNode *pictureToMask = [SKSpriteNode spriteNodeWithImageNamed:@"EnemyBall"];
//    SKSpriteNode *mask = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(200, 200)]; //100 by 100 is the size of the mask
//    SKCropNode *cropNode = [SKCropNode node];
//    cropNode.zPosition = 1;
//    [cropNode addChild: pictureToMask];
//    [cropNode setMaskNode: mask];
//    [self addChild: cropNode];
//    cropNode.position = CGPointMake( CGRectGetMidX (self.frame), CGRectGetMidY (self.frame));
    
    //[self addChild:visualComponent.spriteNode];
   // [self addChild:background];
    
    
    //[self addChild:background];
    //[self addChild:background];
    
    //((OGVisualComponent *) [self.player componentForClass:[OGVisualComponent class]]).spriteNode.lightingBitMask = 1;
    
//    SKLightNode *light = [SKLightNode node];
//    light.falloff = 1.7;
//    light.categoryBitMask = 1;
//    light.ambientColor = [UIColor blackColor];
//    light.lightColor = [[[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:0.5] autorelease];
//    light.shadowColor = [[[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.4] autorelease];
//    light.enabled = YES;
//    
//    
//    [((OGVisualComponent *) [self.player componentForClass:[OGVisualComponent class]]).spriteNode addChild:light];
}

- (SKSpriteNode *)createBackgroundNodeWithColor:(SKColor *)color
{
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:color size:self.size];
    //background.zPosition = 1;
    background.position = CGPointMake(self.size.width/2, self.size.height/2);
    //background.lightingBitMask = 1;
    
    return background;
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

@end
