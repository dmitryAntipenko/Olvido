//
//  OGDarkLevel.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDarkLevel.h"
#import "OGSpriteNode.h"
#import "OGConstants.h"
#import "OGMovementComponent.h"
#import "OGMovementControlComponent.h"
#import "OGTorchComponent.h"

@implementation OGDarkLevel

- (void)didMoveToView:(SKView *)view
{
    self.scene.scaleMode = SKSceneScaleModeAspectFit;
    
    for (OGSpriteNode *sprite in self.spriteNodes)
    {
        if ([sprite.name isEqualToString:kOGPlayerSpriteName])
        {
            OGTorchComponent *torchComponent = (OGTorchComponent *) [sprite.entity componentForClass:[OGTorchComponent class]];
            
            if (torchComponent)
            {
                [self createDarknessWithScreenSize:self.size node:sprite radius:torchComponent.torchRadius];
                [torchComponent torchTurnOn];
            }
        }
        else if ([sprite.name isEqualToString:kOGPortalSpriteName])
        {
            // contact with door
        }
        else if ([sprite.name isEqualToString:kOGEnemySpriteName])
        {
            OGMovementComponent *movementComponent = (OGMovementComponent *) [sprite.entity componentForClass:[OGMovementComponent class]];
            movementComponent.physicsBody = ((SKSpriteNode *)sprite).physicsBody;
            
            [movementComponent startMovement];
        }
    }
    
    [super didMoveToView:view];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    [self.playerControlComponent touchBeganAtPoint:location];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    [self.playerControlComponent touchMovedToPoint:location];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    [self.playerControlComponent touchEndedAtPoint:location];
}

- (void)createDarknessWithScreenSize:(CGSize)size
                                node:(SKNode *)node
                              radius:(CGFloat)radius
{
    CGFloat diagonal = powf(powf(size.height, 2.0) + powf(size.width, 2.0), 0.5) + radius;
    
    SKShapeNode *darkness = [SKShapeNode shapeNodeWithEllipseOfSize:CGSizeMake(diagonal, diagonal)];
    darkness.strokeColor = [SKColor blackColor];
    darkness.zPosition = 1;
    darkness.lineWidth = diagonal - radius;
    
    [node addChild:darkness];
}

- (void)dealloc
{
    [super dealloc];
}

@end
