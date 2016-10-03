//
//  GameScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/27/16.
//  Copyright (c) 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene.h"
#import "OGSettingsScene.h"
#import "SKColor+OGConstantColors.h"
#import "OGGameScene+OGGameSceneCreation.h"
#import "OGEnemy.h"
#import "OGPlayer.h"
#import "OGTimerNode.h"

@interface OGGameScene () <SKPhysicsContactDelegate>

@property (nonatomic, retain) SKNode *background;
@property (nonatomic, retain) SKNode *middleground;
@property (nonatomic, retain) SKNode *foreground;

@property (nonatomic, retain) SKEffectNode *gameOverBlur;
@property (nonatomic, retain) SKNode *gameOverScreen;

@property (nonatomic, retain) OGPlayer *player;
@property (nonatomic, retain) OGTimerNode *timerNode;
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
    
    [self createLayers];
    
    CGPoint playerStartPosition = CGPointMake(CGRectGetMidX(self.frame) - kOGPlayerPlayerRadius,
                                              CGRectGetMidY(self.frame) - kOGPlayerPlayerRadius);
    
    self.player = [OGPlayer playerWithPoint:playerStartPosition];
    
    if (self.player)
    {
        [self addChild:self.player];
    }
    
    for (int i = 0; i < 4; i++)
    {
        OGEnemy *enemy = [OGEnemy enemy];
        [self addChild:enemy];
        [enemy startWithPoint:playerStartPosition];
    }
}

- (void)createLayers
{
    SKEffectNode *gameOverBlur = [SKEffectNode node];
    gameOverBlur.shouldEnableEffects = NO;
    
    CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:@"inputRadius", @1.0f, nil];
    gameOverBlur.filter = blur;
    self.gameOverBlur = gameOverBlur;
    
    self.background = [self createBackground];
    [self addChild:self.background];
    
    self.middleground = [self createMiddleGround];
    [self addChild:self.middleground];
    
    self.foreground = [self createForeground];
    [self addChild:self.foreground];
    
    self.timerNode = (OGTimerNode *) [self.middleground childNodeWithName:kOGTimerNodeName];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    SKNode *touchedNode = [self nodeAtPoint:location];
    
    if ([touchedNode.name isEqualToString:kOGPlayerPlayerName]
        && [((OGPlayer *)touchedNode) isPointInPlayerWithPoint:location])
    {
        self.playerTouched = YES;
    }
    else if ([touchedNode.name isEqualToString:kOGGameSceneMenuButtonSpriteName])
    {
        OGSettingsScene *menuScene = [[OGSettingsScene alloc] initWithSize:self.frame.size];
        [self.view presentScene:menuScene];
        [menuScene release];
    }
    else if ([touchedNode.name isEqualToString:kOGGameSceneRestartButtonSpriteName])
    {
        OGGameScene *menuScene = [[OGGameScene alloc] initWithSize:self.frame.size];
        [self.view presentScene:menuScene];
        [menuScene release];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if (self.player && self.isPlayerTouched)
    {
        self.player.position = location;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.player && self.isPlayerTouched)
    {
        self.playerTouched = NO;
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    self.physicsWorld.speed = 0.0;
    [self.timerNode.timer stop];
    [self.player removeFromParent];

    SKNode *dimPanel = [self createDimPanel];
    [self addChild:dimPanel];
    
    SKNode *gameOverScreen = [self createGameOverScreenWithScore:self.timerNode.timer.ticks];
    [self addChild:gameOverScreen];
    
    [dimPanel runAction:[SKAction fadeAlphaTo:0.3 duration:1.0]];
    [gameOverScreen runAction:[SKAction fadeInWithDuration:1.0]];
}

- (void)update:(CFTimeInterval)currentTime
{
    
}

@end
