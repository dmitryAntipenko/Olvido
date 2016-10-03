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
    
    CGFloat speed = 400;
    
    CGFloat dx = self.player.position.x - self.player.lastPosition2th.x;
    CGFloat dy = self.player.position.y - self.player.lastPosition2th.y;
    
    if (dx == 0.0 && dy == 0.0)
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
        CGFloat v = pow(pow(dx, 2) + pow(dy, 2), 0.5);
        
        CGFloat bX = dx / v * 100;
        CGFloat bY = dy / v * 100;
        
        CGFloat cX = location.x - self.player.position.x;
        CGFloat cY = location.y - self.player.position.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, 0);
        
        //        CGPathAddCurveToPoint(path, NULL, bX, bY, dX, dY, cX, cY);
        CGPathAddQuadCurveToPoint(path, NULL, bX, bY, cX, cY);
        
        
        SKAction *moveToPoint = [SKAction followPath:path speed:speed];
        
        self.player.physicsBody.velocity = CGVectorMake(0, 0);
        [self.player removeAllActions];
        
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
