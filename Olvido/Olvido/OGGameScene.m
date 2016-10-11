//
//  GameScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/27/16.
//  Copyright (c) 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene.h"
#import "OGGameScene+OGGameSceneCreation.h"
#import "SKColor+OGConstantColors.h"

#import "OGTimerNode.h"
#import "OGPlayerNode.h"
#import "OGEnemyNode.h"
#import "OGObstacleNode.h"
#import "OGBonusNode.h"

#import "OGScoreController.h"
#import "OGLevelController.h"
#import "OGTimer.h"

#import "OGLevelChanging.h"
#import "OGCollisionBitMask.h"
#import "OGConstants.h"
#import "OGContactType.h"

NSUInteger const kOGGameSceneTimerInterval = 1;
NSUInteger const kOGGameSceneDefaultEnemyCount = 4;
NSUInteger const kOGGameSceneNodesPositionOffset = 50;
NSUInteger const kOGGameSceneBonusNodesMaximumCount = 10;
NSUInteger const kOGGameSceneBonusTypesCount = 4;
NSUInteger const kOGGameSceneBonusDuration = 5;

CGFloat const kOGGameScenePhysicsWorldGameOverSpeed = 0.0;

CGFloat const kOGGameSceneDimPanelFadeAlphaTo = 0.3;
CGFloat const kOGGameSceneDimPanelDuration = 1.0;

CGFloat const kOGGameSceneGameOverScreenFadeInDuration = 1.0;

CGFloat const kOGGameSceneColorizeActionColorBlendFactor = 1.0;
CGFloat const kOGGameSceneColorizeActionDuration = 0.5;

CGFloat const kOGGameSceneBonusBlinkActionBeforeScaleTo = 1.2;
CGFloat const kOGGameSceneBonusBlinkActionBeforeDuration  = 2.0;
CGFloat const kOGGameSceneBonusBlinkActionAfterScaleTo = 1.0;
CGFloat const kOGGameSceneBonusBlinkActionAfterDuration  = 2.0;

CGFloat const kOGGameSceneBonusSlowMoPhysicsWorldSpeed = 0.6;
CGFloat const kOGGameSceneBonusSpeedUpPhysicsWorldSpeed = 1.4;
CGFloat const kOGGameScenePhysicsWorldDefaultSpeed = 1.0;

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
@property (nonatomic, retain) NSMutableArray<OGEnemyNode *> *enemyNodes;
@property (nonatomic, retain) NSMutableArray<OGBonusNode *> *bonusNodes;

@property (nonatomic, retain) NSArray<NSValue *> *defaultEnemyPositions;

@end

@implementation OGGameScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.isSceneCreated)
    {
        self.backgroundColor = [SKColor backgroundLightGrayColor];
        self.enemyNodes = [[NSMutableArray alloc] init];
        self.bonusNodes = [[NSMutableArray alloc] init];
        
        [self createDefaultValues];
        [self createSceneContents];
        self.sceneCreated = YES;
    }
}

#pragma mark - Scene creation

- (void)createDefaultValues
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    self.defaultEnemyPositions = [[NSArray alloc] initWithObjects:
                                  [NSValue valueWithCGPoint:CGPointMake(kOGGameSceneNodesPositionOffset, kOGGameSceneNodesPositionOffset)],
                                  [NSValue valueWithCGPoint:CGPointMake(width - kOGGameSceneNodesPositionOffset, kOGGameSceneNodesPositionOffset)],
                                  [NSValue valueWithCGPoint:CGPointMake(width - kOGGameSceneNodesPositionOffset, height - kOGGameSceneNodesPositionOffset)],
                                  [NSValue valueWithCGPoint:CGPointMake(kOGGameSceneNodesPositionOffset, height - kOGGameSceneNodesPositionOffset)],
                                  nil];
}

- (void)createSceneContents
{
    self.name = kOGObstacleNodeName;
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = kOGCollisionBitMaskObstacle;
    self.physicsBody.collisionBitMask = kOGCollisionBitMaskPlayer | kOGCollisionBitMaskEnemy;
    self.physicsBody.contactTestBitMask = kOGCollisionBitMaskPlayer;
    
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
        self.playerNode.position = CGPointMake(CGRectGetMidX(self.frame),
                                               CGRectGetMidY(self.frame));
        
        [self.foreground addChild:self.playerNode];
    }
    
    [self createEnemies];
}

- (void)createEnemies
{
    for (unsigned i = 0; i < kOGGameSceneDefaultEnemyCount; i++)
    {
        OGEnemyNode *enemyNode = [OGEnemyNode enemyNode];
        
        if (enemyNode)
        {
            [self.foreground addChild:enemyNode];
            [self.enemyNodes addObject:enemyNode];
            [enemyNode startWithPoint:self.defaultEnemyPositions[i].CGPointValue];
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

#pragma mark - Touches detection

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:location];
    
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        [self.playerNode moveToPoint:location];
    }
    
    [self handleGameOverEventsWithNode:touchedNode];
}

- (void)handleGameOverEventsWithNode:(SKNode *)touchedNode
{
    if ([touchedNode.name isEqualToString:kOGGameSceneRestartButtonSpriteName])
    {
        OGGameScene *gameScene = [[OGGameScene alloc] initWithSize:self.frame.size];
        [self.view presentScene:gameScene];
        [gameScene release];
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

#pragma mark - Collision detection

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    OGContactType contactType = [self contactType:contact];
    
    if (contactType == kOGContactTypeGameOver)
    {
        [self showGameOverScreen];
    }
    else if (contactType == kOGContactTypePlayerDidGetBonus)
    {
        [self applyBonusWithType:((OGBonusNode *) contact.bodyA.node).bonusType];
        [contact.bodyA.node removeFromParent];
        [self.bonusNodes removeObject:(OGBonusNode*) contact.bodyA.node];
    }
    else if (contactType == kOGContactTypePlayerDidTouchObstacle)
    {
        [self.playerNode moveByInertia];
    }
}

- (OGContactType)contactType:(SKPhysicsContact *)contact
{
    SKNode *nodeA = contact.bodyA.node;
    SKNode *nodeB = contact.bodyB.node;
    
    if ([nodeA.name isEqualToString:kOGPlayerNodeName] && [nodeB.name isEqualToString:kOGEnemyNodeName])
    {
        return kOGContactTypeGameOver;
    }
    else if (([nodeA.name isEqualToString:kOGPlayerNodeName] && [nodeB.name isEqualToString:kOGBonusNodeName])
             || ([nodeB.name isEqualToString:kOGPlayerNodeName] && [nodeA.name isEqualToString:kOGBonusNodeName]))
    {
        return kOGContactTypePlayerDidGetBonus;
    }
    else if ([nodeA.name isEqualToString:kOGObstacleNodeName] && [nodeB.name isEqualToString:kOGPlayerNodeName])
    {
        return kOGContactTypePlayerDidTouchObstacle;
    }
    
    return kOGContactTypeNone;
}

- (void)showGameOverScreen
{
    self.physicsWorld.speed = kOGGameScenePhysicsWorldGameOverSpeed;
    [self.timer invalidate];
    
    [self.playerNode removeFromParent];
    
    SKNode *dimPanel = [self createDimPanel];
    [self addChild:dimPanel];
    
    SKNode *gameOverScreen = [self createGameOverScreenWithScore:self.scoreController.score];
    [self addChild:gameOverScreen];
    
    [dimPanel runAction:[SKAction fadeAlphaTo:kOGGameSceneDimPanelFadeAlphaTo duration:kOGGameSceneDimPanelDuration]];
    [gameOverScreen runAction:[SKAction fadeInWithDuration:kOGGameSceneGameOverScreenFadeInDuration]];
}

- (void)update:(CFTimeInterval)currentTime
{
    [self.playerNode positionDidUpdate];
}

#pragma mark - LevelChanging methods

- (void)changeBackgroundWithColor:(SKColor *)color
{
    [self runActionWithColor:color target:self];
}

-(void)changeAccentWithColor:(SKColor *)color
{
    self.timerNode.fontColor = color;
    
    SKNode *borderCropNode = [self.background childNodeWithName:kOGGameSceneBorderCropNodeName];
    SKSpriteNode *borderNode = (SKSpriteNode *) [borderCropNode childNodeWithName:kOGGameSceneBorderNodeName];
    [self runActionWithColor:color target:borderNode];
    
    SKSpriteNode *timerCircleNode = (SKSpriteNode *) [self.background childNodeWithName:kOGGameSceneTimerCircleNodeName];
    [self runActionWithColor:color target:timerCircleNode];
}

- (void)changePlayerWithColor:(SKColor *)color
{
    [self runActionWithColor:color target:self.playerNode.appearance];
}

- (void)changeEnemiesWithColor:(SKColor *)color enemyCount:(NSNumber *)count
{
    for (OGEnemyNode *enemy in self.enemyNodes)
    {
        [self runActionWithColor:color target:enemy.appearance];
    }
}

- (void)changeObstacles:(NSArray *)obstacles
{
    //NSLog(@"%@", obstacles);
}

- (void)runActionWithColor:(SKColor *)color target:(SKNode *)target
{
    [target runAction:[SKAction colorizeWithColor:color colorBlendFactor:kOGGameSceneColorizeActionColorBlendFactor duration:kOGGameSceneColorizeActionDuration]];
}

- (void)addRandomBonus
{
    if (self.bonusNodes.count < kOGGameSceneBonusNodesMaximumCount)
    {
        OGBonusNode *bonus = [OGBonusNode bonusNodeWithColor:[SKColor yellowColor] type:rand() % kOGGameSceneBonusTypesCount];
        
        bonus.position = ogRandomPoint(kOGGameSceneNodesPositionOffset,
                                      self.frame.size.width - kOGGameSceneNodesPositionOffset,
                                      kOGGameSceneNodesPositionOffset,
                                      self.frame.size.height - kOGGameSceneNodesPositionOffset);
        
        [self.bonusNodes addObject:bonus];
        [self.foreground addChild:bonus];
        
        SKAction *blinkAction = [SKAction sequence:@[
                                                    [SKAction scaleTo:kOGGameSceneBonusBlinkActionBeforeScaleTo duration:kOGGameSceneBonusBlinkActionBeforeDuration],
                                                    [SKAction scaleTo:kOGGameSceneBonusBlinkActionAfterScaleTo duration:kOGGameSceneBonusBlinkActionAfterDuration]
                                                    ]];
        
        [bonus runAction:[SKAction repeatActionForever:blinkAction]];
    }
}

- (void)applyBonusWithType:(OGBonusType)type
{
    if (type == kOGBonusTypeSlowMo)
    {
        self.physicsWorld.speed = kOGGameSceneBonusSlowMoPhysicsWorldSpeed;
        
        [self runAction:[SKAction waitForDuration:kOGGameSceneBonusDuration] completion:^()
        {
            self.physicsWorld.speed = kOGGameScenePhysicsWorldDefaultSpeed;
        }];
    }
    else if (type == kOGBonusTypeSpeedUp)
    {
        self.physicsWorld.speed = kOGGameSceneBonusSpeedUpPhysicsWorldSpeed;
        
        [self runAction:[SKAction waitForDuration:kOGGameSceneBonusDuration] completion:^()
         {
             self.physicsWorld.speed = kOGGameScenePhysicsWorldDefaultSpeed;
         }];
    }
}

- (void)dealloc
{
    [_background release];
    [_foreground release];
    [_middleground release];
    [_timer release];
    [_timerNode release];
    [_levelController release];
    [_scoreController release];
    [_playerNode release];
    [_enemyNodes release];
    [_bonusNodes release];
    
    [super dealloc];
}

@end
