//
//  OGInitialLevel.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGInitialLevel.h"
#import "OGSpriteNode.h"
#import "OGMovementComponent.h"
#import "OGMovementControlComponent.h"
#import "OGConstants.h"

NSString *const kOGInitialLevelZombie = @"Zombie";
NSString *const kOGInitialLevelFrank = @"Frank";
NSString *const kOGInitialLevelDoor = @"Door";

@implementation OGInitialLevel

- (void)didMoveToView:(SKView *)view
{
    self.scene.scaleMode = SKSceneScaleModeAspectFit;
    
    for (OGSpriteNode *sprite in self.spriteNodes)
    {
        if ([sprite.name isEqualToString:kOGInitialLevelFrank])
        {
            // add when decide with player movement control
        }
        else if ([sprite.name isEqualToString:kOGInitialLevelDoor])
        {
            // contact with door
        }
        else if ([sprite.name isEqualToString:kOGInitialLevelZombie])
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

- (void)dealloc
{
    [super dealloc];
}

@end
