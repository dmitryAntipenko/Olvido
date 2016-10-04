//
//  GameScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/27/16.
//  Copyright (c) 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene.h"
#import "SKColor+OGConstantColors.h"
#import "OGGameScene+OGGameSceneCreation.h"
#import "OGEnemy.h"
#import "OGPlayer.h"

@interface OGGameScene () <SKPhysicsContactDelegate>

@property (nonatomic, retain) SKNode *background;
@property (nonatomic, retain) SKNode *middleground;
@property (nonatomic, retain) SKNode *foreground;

@property (nonatomic, assign) OGPlayer *player;
@property (nonatomic, getter=isPlayerTouched) BOOL playerTouched;
@property (nonatomic, getter=isSceneCreated) BOOL sceneCreated;

@end

@implementation OGGameScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.isSceneCreated)
    {
        self.backgroundColor = [SKColor backgroundLightGrayColor];
        
        [self createSceneContents];
        self.sceneCreated = YES;
    }
}

- (void)createSceneContents
{
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = 0x1 << 0;
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    self.physicsWorld.contactDelegate = self;
    
    self.background = [self createBackground];
    [self addChild:self.background];
    
    self.middleground = [self createMiddleGround];
    [self addChild:self.middleground];
    
    self.foreground = [self createForeground];
    [self addChild:self.foreground];
    
    
    CGPoint playerStartPosition = CGPointMake(CGRectGetMidX(self.frame) - kOGPlayerPlayerRadius,
                                              CGRectGetMidY(self.frame) - kOGPlayerPlayerRadius);
    
    self.player = [OGPlayer playerWithPoint:playerStartPosition];
    
    if (self.player)
    {
        [self addChild:self.player];
    }
    
    //    for (int i = 0; i < 10; i++)
    //    {
    //        OGEnemy *enemy = [OGEnemy enemy];
    //        [self addChild:enemy];
    //        [enemy startWithPoint:playerStartPosition];
    //    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    CGFloat speed = 100;
    
    CGVector displacementVector = CGVectorMake(location.x - self.player.position.x,
                                               location.y - self.player.position.y);
    
    if (self.player.position.x - self.player.lastPosition2th.x == 0.0
        && self.player.position.y - self.player.lastPosition2th.y == 0.0)
    {
        CGVector direction = CGVectorMake(location.x - self.player.position.x,
                                          location.y - self.player.position.y);
        
        CGFloat l = pow(pow(direction.dx, 2) + pow(direction.dy, 2), 0.5);
        
        CGFloat x = direction.dx * speed / l * self.player.physicsBody.mass;
        CGFloat y = direction.dy * speed / l * self.player.physicsBody.mass;
        
        [self.player.physicsBody applyImpulse:CGVectorMake(x, y)];
    }
    else
    {
        CGVector displacementVector = CGVectorMake(location.x - self.player.position.x,
                                                   location.y - self.player.position.y);
        CGVector movementVector = CGVectorMake(self.player.position.x - self.player.lastPosition2th.x,
                                               self.player.position.y - self.player.lastPosition2th.y);
        
        CGFloat v = pow(pow(movementVector.dx, 2) + pow(movementVector.dy, 2), 0.5);
        
//        CGFloat scalarMult = displacementVector.dx * movementVector.dx + displacementVector.dy * movementVector.dy;
        
        CGFloat l = pow(pow(displacementVector.dx, 2) + pow(displacementVector.dy, 2), 0.5) / 3;
        
        CGFloat bX = movementVector.dx / v * l;
        CGFloat bY = movementVector.dy / v * l;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, 0);
        
//        if (scalarMult < 0)
//        {
//            CGFloat dX = pow(10000 / (pow(displacementVector.dx / displacementVector.dy, 2) + 1), 0.5);
//            
//            if (displacementVector.dx / displacementVector.dy >= movementVector.dx / movementVector.dy)
//            {
//                dX *= -1;
//            }
//            
//            CGFloat dY = (-1) * displacementVector.dx * dX / displacementVector.dy;
//            
//            CGPathAddCurveToPoint(path, NULL, bX, bY, dX, dY, displacementVector.dx, displacementVector.dy);
//        }
//        else
//        {
            CGPathAddQuadCurveToPoint(path, NULL, bX, bY, displacementVector.dx, displacementVector.dy);
//        }
        
        SKAction *moveToPoint = [SKAction followPath:path speed:speed];
        
        self.player.physicsBody.velocity = CGVectorMake(0, 0);
        [self.player removeAllActions];
        
        //debug
        SKNode *node = [self childNodeWithName:@"pathNode"];
        [node removeFromParent];
        SKShapeNode *pathNode = [SKShapeNode shapeNodeWithPath:path];
        pathNode.strokeColor = [SKColor blackColor];
        pathNode.position = self.player.position;
        pathNode.name = @"pathNode";
        [self addChild:pathNode];
        //
        
        [self.player runAction:moveToPoint completion:^{
            CGVector direction = CGVectorMake(self.player.position.x - self.player.lastPosition2th.x,
                                              self.player.position.y - self.player.lastPosition2th.y);
            
            CGFloat l = pow(pow(direction.dx, 2) + pow(direction.dy, 2), 0.5);
            
            CGFloat x = direction.dx * speed / l * self.player.physicsBody.mass;
            CGFloat y = direction.dy * speed / l * self.player.physicsBody.mass;
            
            [self.player.physicsBody applyImpulse:CGVectorMake(x, y)];
        }];
        
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if (self.isPlayerTouched)
    {
        self.player.position = location;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isPlayerTouched)
    {
        self.playerTouched = NO;
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"PROGRAV");
}

- (void)update:(CFTimeInterval)currentTime
{
    self.player.lastPosition2th = self.player.lastPosition1th;
    self.player.lastPosition1th = self.player.position;
}

@end
