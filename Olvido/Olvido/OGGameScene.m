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

BOOL const kOGGameSceneControllSwipe = NO;

@interface OGGameScene ()

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
    CGRect borderEdgesRect = CGRectMake(self.frame.origin.x + kOGGameSceneBorderSize,
                                        self.frame.origin.y + kOGGameSceneBorderSize,
                                        self.frame.size.width - kOGGameSceneBorderSize * 2.0,
                                        self.frame.size.height - kOGGameSceneBorderSize * 2.0);
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:borderEdgesRect];
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    
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
    
    [self addChild:[OGEnemy enemy]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];

    if (kOGGameSceneControllSwipe)
    {
        SKNode *touchedNode = [self nodeAtPoint:location];
        
        if ([touchedNode.name isEqualToString:kOGPlayerPlayerName]
            && [((OGPlayer *)touchedNode) isPointInPlayerWithPoint:location])
        {
            self.playerTouched = YES;
        }
    }
    else
    {
        self.player.touchPoint = location;
        
        [self.player calculateAngle];
        self.player.touch = YES;
        
     //   [self.player changePlayerVelocityWithPoint:location];
        //[self.player changePlayerArcVelocityWithPoint:location];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
//    if (self.isPlayerTouched && kOGGameSceneControllSwipe)
//    {
//        self.player.position = location;
//    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isPlayerTouched)
    {
        self.playerTouched = NO;
    }
}

- (void)update:(CFTimeInterval)currentTime
{
    if (self.player.isTouched)
    {
        [self.player changePlayerArcVelocity];
    }
}

@end
