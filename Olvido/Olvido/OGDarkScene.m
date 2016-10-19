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
CGFloat const kOGDarkSceneSpeedFactor = 0.3;

@implementation OGDarkScene

- (void)createSceneContents
{
    [super createSceneContents];
    
    self.backgroundColor = [SKColor gameBlack];
    
    [self addChild:[self createBackgroundBorderWithColor:[SKColor gameDarkRed]]];
    
    [self createEnemies];
    
    for (OGEntity *enemy in self.enemies)
    {
        ((OGMovementComponent *) [enemy componentForClass:[OGMovementComponent class]]).speedFactor = kOGDarkSceneSpeedFactor;
        ((OGVisualComponent *) [enemy componentForClass:[OGVisualComponent class]]).color = [SKColor gameWhite];
    }
    
    [self createPlayer];
    
    self.playerMovementControlComponent.speedFactor = kOGDarkSceneSpeedFactor;
    
    OGVisualComponent *visualComponent = (OGVisualComponent *) [self.player componentForClass:[OGVisualComponent class]];
    
    OGTorchComponent *torchComponent = [[OGTorchComponent alloc] initWithTorchSprite:visualComponent.spriteNode
                                                                         tourchRadius:kOGDarkSceneDarknessRadius];
    [self.player addComponent:torchComponent];
    [torchComponent torchTurnOn];
    [torchComponent createDarknessWithSize:self.size];
    
    [torchComponent release];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    [super didBeginContact:contact];
}

@end
