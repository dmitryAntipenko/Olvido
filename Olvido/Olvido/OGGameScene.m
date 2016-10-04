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

BOOL const kOGGameSceneControllSwipe = NO;

NSString *const kOGMovePlayerToPointActionKey = @"movePlayerToPointActionKey";
NSString *const kOGBorderNodeName = @"border";
CGFloat const kOGPlayerSpeed = 400;

@interface OGGameScene () <SKPhysicsContactDelegate>

@property (nonatomic, retain) SKNode *background;
@property (nonatomic, retain) SKNode *middleground;
@property (nonatomic, retain) SKNode *foreground;

@property (nonatomic, retain) OGPlayer *player;
@property (nonatomic, retain) OGTimerNode *timerNode;
@property (nonatomic, getter=isPlayerDragStarted) BOOL playerDragStart;
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
    self.name = kOGBorderNodeName;
    
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
    
    if ([self.controlType isEqualToString:kOGSettingsSceneSwipeButton])
    {
        if ([touchedNode.name isEqualToString:kOGPlayerPlayerName]
            && [((OGPlayer *)touchedNode) isPointInPlayerWithPoint:location])
        {
            self.playerDragStart = YES;
        }
    }
    else if ([self.controlType isEqualToString:kOGSettingsSceneTapButton])
    {
        [self.player changePlayerVelocityWithPoint:location];
    }
    
    [self handleGameOverEventsWithNode:touchedNode];
    [self movePlayerToPoint:location];
}

- (void)handleGameOverEventsWithNode:(SKNode *)touchedNode
{
    if ([touchedNode.name isEqualToString:kOGGameSceneMenuButtonSpriteName])
    {
        OGSettingsScene *menuScene = [[OGSettingsScene alloc] initWithSize:self.frame.size];
        [self.view presentScene:menuScene];
        [menuScene release];
    }
    else if ([touchedNode.name isEqualToString:kOGGameSceneRestartButtonSpriteName])
    {
        OGGameScene *gameScene = [[OGGameScene alloc] initWithSize:self.frame.size];
        gameScene.controlType = self.controlType;
        [self.view presentScene:gameScene];
        [gameScene release];
    }
}

- (void)movePlayerToPoint:(CGPoint)point
{
    self.player.physicsBody.velocity = CGVectorMake(0, 0);
    [self.player removeActionForKey:kOGMovePlayerToPointActionKey];
    
    CGVector displacementVector = CGVectorMake(point.x - self.player.position.x,
                                               point.y - self.player.position.y);
    
    if (self.player.position.x - self.player.lastPosition.x == 0.0
        && self.player.position.y - self.player.lastPosition.y == 0.0)
    {
        
        CGFloat l = pow(pow(displacementVector.dx, 2) + pow(displacementVector.dy, 2), 0.5);
        
        CGFloat x = displacementVector.dx * kOGPlayerSpeed / l * self.player.physicsBody.mass;
        CGFloat y = displacementVector.dy * kOGPlayerSpeed / l * self.player.physicsBody.mass;
        
        [self.player.physicsBody applyImpulse:CGVectorMake(x, y)];
    }
    else
    {
        CGVector movementVector = CGVectorMake(self.player.position.x - self.player.lastPosition.x,
                                               self.player.position.y - self.player.lastPosition.y);
        
        CGFloat v = pow(pow(movementVector.dx, 2) + pow(movementVector.dy, 2), 0.5);
        
        CGFloat l = pow(pow(displacementVector.dx, 2) + pow(displacementVector.dy, 2), 0.5) / 3;
        
        CGFloat bX = movementVector.dx / v * l;
        CGFloat bY = movementVector.dy / v * l;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, 0);
        
        CGPathAddQuadCurveToPoint(path, NULL, bX, bY, displacementVector.dx, displacementVector.dy);
        
        SKAction *moveToPoint = [SKAction followPath:path speed:kOGPlayerSpeed];
        
        SKAction *performComplitionHandler = [SKAction runBlock:^{
            [self performSelector:@selector(movePlayerToPointCompletionHandlerWithOuterVectorStartPointAsArray:)
                       withObject:@[@(displacementVector.dx - bX),
                                    @(displacementVector.dy - bY)]];
        }];
        
        [self.player runAction:[SKAction sequence:@[
                                                    moveToPoint,
                                                    performComplitionHandler
                                                    ]]
                       withKey:kOGMovePlayerToPointActionKey];
    }
}

- (void)movePlayerToPointCompletionHandlerWithOuterVectorStartPointAsArray:(NSArray<NSNumber *> *)arr
{
    CGVector outerVector = CGVectorMake(0.0, 0.0);
    
    if (arr)
    {
        outerVector = CGVectorMake((CGFloat)[arr[0] doubleValue], (CGFloat)[arr[1] doubleValue]);
    }
    
    CGFloat l = pow(pow(outerVector.dx, 2) + pow(outerVector.dy, 2), 0.5);
    
    CGFloat x = outerVector.dx * kOGPlayerSpeed * self.player.physicsBody.mass / l;
    CGFloat y = outerVector.dy * kOGPlayerSpeed * self.player.physicsBody.mass / l;
    
    [self.player.physicsBody applyImpulse:CGVectorMake(x, y)];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if (self.isPlayerDragStarted && [self.controlType isEqualToString:kOGSettingsSceneSwipeButton])
    {
        self.player.position = location;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isPlayerDragStarted)
    {
        self.playerDragStart = NO;
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    NSString *nameA = contact.bodyA.node.name;
    NSString *nameB = contact.bodyB.node.name;
    
    if (([nameA isEqualToString:self.name] && [nameB isEqualToString:self.player.name])
        || ([nameB isEqualToString:self.name] && [nameA isEqualToString:self.player.name]))
    {
        SKAction *moveAction = [self.player actionForKey:kOGMovePlayerToPointActionKey];
        if (moveAction)
        {
            CGPoint pointForImpulse = CGPointZero;
            
            pointForImpulse = CGPointMake(2 * self.player.position.x - self.player.lastPosition.x,
                                          2 * self.player.position.y - self.player.lastPosition.y);
            
            [self.player removeActionForKey:kOGMovePlayerToPointActionKey];
            
            [self movePlayerToPoint:pointForImpulse];
        }
    }
    
    if (([nameA isEqualToString:kOGEnemyNodeName] && [nameB isEqualToString:self.player.name])
        || ([nameB isEqualToString:kOGEnemyNodeName] && [nameA isEqualToString:self.player.name]))
    {
        [self showGameOverScreen];
    }
}

- (void)showGameOverScreen
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
    self.player.lastPosition = self.player.position;
}

@end
