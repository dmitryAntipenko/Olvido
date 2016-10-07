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
#import "OGTimerNode.h"
#import "OGTimer.h"
#import "OGScoreController.h"
#import "OGLevelController.h"
#import "OGLevelChanging.h"
#import "OGPlayerNode.h"
#import "OGConstants.h"
#import "OGEnemyNode.h"

NSUInteger const kOGGameSceneTimerInterval = 1.0;

@interface OGGameScene () <SKPhysicsContactDelegate, OGLevelChanging>

@property (nonatomic, retain) SKNode *background;
@property (nonatomic, retain) SKNode *middleground;
@property (nonatomic, retain) SKNode *foreground;
@property (nonatomic, retain) OGTimerNode *timerNode;

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) OGScoreController *scoreController;
@property (nonatomic, retain) OGLevelController *levelController;

@property (nonatomic, getter=isSceneCreated) BOOL sceneCreated;

@property (nonatomic, retain) OGPlayerNode *playerNode;

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
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kOGGameSceneTimerInterval
                                                  target:self
                                                selector:@selector(timerTick)
                                                userInfo:nil
                                                 repeats:YES];
    
    OGLevelController *levelController = [[OGLevelController alloc] init];
    self.levelController = levelController;
    self.levelController.gameScene = self;
    
    OGScoreController *scoreController = [[OGScoreController alloc] initWithLevelController:self.levelController];
    self.scoreController = scoreController;
    
    [levelController release];
    [scoreController release];
    
    [self createLayers];
    
    self.playerNode = [OGPlayerNode playerNodeWithColor:[SKColor blackColor]];
    
    if (self.playerNode)
    {
        self.playerNode.position = CGPointMake(100, 100);
        
        [self.foreground addChild:self.playerNode];
    }
    
    for (unsigned i = 0; i < 10; i++)
    {
        OGEnemyNode *enemyNode = [OGEnemyNode enemyNode];

        if (enemyNode)
        {
            [self.foreground addChild:enemyNode];
            [enemyNode startWithPoint:CGPointMake(100, 100)];
        }
    }
    
    
}

- (void)timerTick
{
    [self.scoreController incrementScore];
    self.timerNode.text = self.scoreController.score.stringValue;
}

- (void)createLayers
{
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
    //...
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        [self.playerNode moveToPoint:location];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //...
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //...
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    //...
}

- (void)showGameOverScreen
{
    self.physicsWorld.speed = 0.0;
    [self.timer invalidate];
    
    SKNode *dimPanel = [self createDimPanel];
    [self addChild:dimPanel];
    
    SKNode *gameOverScreen = [self createGameOverScreenWithScore:self.scoreController.score];
    [self addChild:gameOverScreen];
    
    [dimPanel runAction:[SKAction fadeAlphaTo:0.3 duration:1.0]];
    [gameOverScreen runAction:[SKAction fadeInWithDuration:1.0]];
}

- (void)update:(CFTimeInterval)currentTime
{
    [self.playerNode positionDidUpdate];
}

- (void)changeBackgroundWithColor:(UIColor *)color
{
    self.backgroundColor = color;
}

-(void)changeAccentWithColor:(UIColor *)color
{
    self.timerNode.fontColor = color;
    
    SKNode *borderCropNode = [self.background childNodeWithName:kOGGameSceneBorderCropNodeName];
    SKSpriteNode *borderNode = (SKSpriteNode *) [borderCropNode childNodeWithName:kOGGameSceneBorderNodeName];
    borderNode.color = color;
    
    SKNode *timerCircleCropNode = [self.background childNodeWithName:kOGGameSceneTimerCircleCropNodeName];
    SKSpriteNode *timerCircleNode = (SKSpriteNode *) [timerCircleCropNode childNodeWithName:kOGGameSceneTimerCircleNodeName];
    timerCircleNode.color = color;
}

- (void)changePlayerWithColor:(SKColor *)color
{
    NSLog(@"%@", color);
}

- (void)changeEnemiesWithColor:(SKColor *)color enemyCount:(NSNumber *)count
{
    NSLog(@"%@", color);
}

- (void)changeObstacles:(NSArray *)obstacles
{
    NSLog(@"%@", obstacles);
}

@end
