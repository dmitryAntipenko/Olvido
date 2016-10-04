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

NSString *const kOGMovePlayerToPointActionKey = @"movePlayerToPointActionKey";
NSString *const kOGBorderNodeName = @"border";
CGFloat const kOGPlayerSpeed = 400;

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
    self.physicsBody.contactTestBitMask = 0x0;
    
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    self.physicsWorld.contactDelegate = self;
    
    self.name = kOGBorderNodeName;
    
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
    
    for (int i = 0; i < 5; i++)
    {
        OGEnemy *enemy = [OGEnemy enemy];
        [self addChild:enemy];
        [enemy startWithPoint:playerStartPosition];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    [self movePlayerToPoint:location];
}

- (void)movePlayerToPoint:(CGPoint)point
{
    self.player.physicsBody.velocity = CGVectorMake(0, 0);
    [self.player actionForKey:kOGMovePlayerToPointActionKey];
    
    CGVector displacementVector = CGVectorMake(point.x - self.player.position.x,
                                               point.y - self.player.position.y);
    
    if (self.player.position.x - self.player.lastPosition2th.x == 0.0
        && self.player.position.y - self.player.lastPosition2th.y == 0.0)
    {
        
        CGFloat l = pow(pow(displacementVector.dx, 2) + pow(displacementVector.dy, 2), 0.5);
        
        CGFloat x = displacementVector.dx * kOGPlayerSpeed / l * self.player.physicsBody.mass;
        CGFloat y = displacementVector.dy * kOGPlayerSpeed / l * self.player.physicsBody.mass;
        
        [self.player.physicsBody applyImpulse:CGVectorMake(x, y)];
    }
    else
    {
        CGVector movementVector = CGVectorMake(self.player.position.x - self.player.lastPosition2th.x,
                                               self.player.position.y - self.player.lastPosition2th.y);
        
        CGFloat v = pow(pow(movementVector.dx, 2) + pow(movementVector.dy, 2), 0.5);
        
        CGFloat l = pow(pow(displacementVector.dx, 2) + pow(displacementVector.dy, 2), 0.5) / 3;
        
        CGFloat bX = movementVector.dx / v * l;
        CGFloat bY = movementVector.dy / v * l;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, 0);
        
        CGPathAddQuadCurveToPoint(path, NULL, bX, bY, displacementVector.dx, displacementVector.dy);
        
        SKAction *moveToPoint = [SKAction followPath:path speed:kOGPlayerSpeed];
        
        [self.player runAction:[SKAction sequence:@[
                                                    moveToPoint,
                                                    [SKAction performSelector:@selector(movePlayerToPointCompletionHandler)
                                                                     onTarget:self]
                                                    ]] withKey:kOGMovePlayerToPointActionKey];
    }
}

- (void)movePlayerToPointCompletionHandler
{
    CGVector direction = CGVectorMake(self.player.position.x - self.player.lastPosition2th.x,
                                      self.player.position.y - self.player.lastPosition2th.y);
    
    CGFloat l = pow(pow(direction.dx, 2) + pow(direction.dy, 2), 0.5);
    
    CGFloat x = direction.dx * kOGPlayerSpeed / l * self.player.physicsBody.mass;
    CGFloat y = direction.dy * kOGPlayerSpeed / l * self.player.physicsBody.mass;
    
    [self.player.physicsBody applyImpulse:CGVectorMake(x, y)];
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
    NSString *nameA = contact.bodyA.node.name;
    NSString *nameB = contact.bodyB.node.name;
    
    if (([nameA isEqualToString:@"border"] && [nameB isEqualToString:@"player"])
        || ([nameB isEqualToString:@"border"] && [nameA isEqualToString:@"player"]))
    {
        SKAction *moveAction = [self.player actionForKey:kOGMovePlayerToPointActionKey];
        if (moveAction)
        {
            CGPoint pointForImpulse = CGPointZero;
            
            pointForImpulse = CGPointMake(2 * self.player.position.x - self.player.lastPosition2th.x,
                                          2 * self.player.position.y - self.player.lastPosition2th.y);
            
            self.player.lastPosition1th = self.player.position;
            self.player.lastPosition2th = self.player.position;
            [self.player removeActionForKey:kOGMovePlayerToPointActionKey];
            
            [self movePlayerToPoint:pointForImpulse];
        }
    }
    
    if (([nameA isEqualToString:@"enemy"] && [nameB isEqualToString:@"player"])
        || ([nameB isEqualToString:@"enemy"] && [nameA isEqualToString:@"player"]))
    {
        //GAME OVER
    }
}

- (void)update:(CFTimeInterval)currentTime
{
    self.player.lastPosition2th = self.player.lastPosition1th;
    self.player.lastPosition1th = self.player.position;
}

@end
