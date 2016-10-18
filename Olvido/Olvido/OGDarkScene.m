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
NSString *const kOGDarkSceneLightImageName = @"LightImg";

@implementation OGDarkScene

- (void)createSceneContents
{
    [super createSceneContents];
    
    self.backgroundColor = [SKColor gameGreen];
    
    
    [self addChild:[self createBackgroundBorderWithColor:[SKColor gameDarkRed]]];
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
    [self.player addComponent:[[OGTorchComponent alloc] initWithTorchSprite:visualComponent.spriteNode tourchRadius:100]];
    [((OGTorchComponent *)[self.player componentForClass:[OGTorchComponent class]]) torchTurnOn];
//    visualComponent.spriteNode.zPosition = 2;
    visualComponent.color = [SKColor gameBlack];
    
    [((OGTorchComponent *)[self.player componentForClass:[OGTorchComponent class]]) createDarknessWithSize:self.size];
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
    
    
    
//    SKSpriteNode *pic = [self createBackgroundNodeWithColor:[SKColor orangeColor]];
//    pic.name = @"PictureNode";
//    
   // UIImage *image = [UIImage imag
    //SKTexture *all = [SKTexture text]
    
//    SKTexture *maskText = [SKTexture textureWithImageNamed:@"EnemyBall"];
//    SKTexture *newTexture = [SKTexture textureWithRect:maskText.textureRect inTexture:maskText];
//    
//    SKSpriteNode *mask = [SKSpriteNode spriteNodeWithImageNamed:@"EnemyBall"];
//    CGFloat screenDiagonal = powf(powf(self.size.height, 2.0) + powf(self.size.width, 2.0), 0.5) + kOGDarkSceneDarknessRadius;
//    SKShapeNode *mask = [SKShapeNode shapeNodeWithEllipseOfSize:CGSizeMake(100, 100)];
//    mask.alpha = 0.0;
//    mask.lineWidth = 100;
   // mask.size=CGSizeMake(100, 100);
    //mask.position=CGPointMake(50, 50);
//    
//    SKCropNode *cropNode = [SKCropNode node];
//    cropNode.position=CGPointMake(0.0, 0.0);
//
//
//    
//    [cropNode addChild:mask];
//    [cropNode setMaskNode:visualComponent.spriteNode];
//    
//    [pic addChild:cropNode];
//    [self addChild:pic];
//    
    
    
    
    
//    CGFloat screenDiagonal = powf(powf(self.size.height, 2.0) + powf(self.size.width, 2.0), 0.5) + kOGDarkSceneDarknessRadius;
//    SKShapeNode *darknessBackground = [SKShapeNode shapeNodeWithEllipseOfSize:CGSizeMake(screenDiagonal, screenDiagonal)];
//    darknessBackground.strokeColor = [SKColor blackColor];
//    darknessBackground.zPosition = 1;
//    darknessBackground.lineWidth = screenDiagonal - (CGFloat)kOGDarkSceneDarknessRadius;
//    
//    SKSpriteNode *light = [SKSpriteNode spriteNodeWithImageNamed:kOGDarkSceneLightImageName];
//    light.zPosition = 1;
//    light.size = CGSizeMake(kOGDarkSceneDarknessRadius*1.7, kOGDarkSceneDarknessRadius*1.7);
//    
//    [darknessBackground addChild:light];
//    [visualComponent.spriteNode addChild:darknessBackground];
//    visualComponent.spriteNode.zPosition = 2000;
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
