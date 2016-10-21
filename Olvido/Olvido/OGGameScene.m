//
//  OGGameScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene.h"

CGFloat const kOGGameSceneStatusBarHidingOffset = 50.0;

CGFloat const kOGGameSceneSpeedStop = 0.0;
CGFloat const kOGGameSceneSpeedDefault = 1.0;

@interface OGGameScene ()

@property (nonatomic, retain) NSMutableArray<OGEntity *> *mutableEnemies;
@property (nonatomic, retain) NSMutableArray<OGEntity *> *mutablePortals;
@property (nonatomic, retain) NSMutableArray<OGEntity *> *mutableCoins;

@property (nonatomic, assign) BOOL shouldShowStatusBar;

@end

@implementation OGGameScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self)
    {
        _mutableEnemies = [[NSMutableArray alloc] init];
        _mutablePortals = [[NSMutableArray alloc] init];
        _mutableCoins = [[NSMutableArray alloc] init];
        _shouldShowStatusBar = NO;
    }
    else
    {
        [self release];
        self = nil;
    }
    
    return self;
}

#pragma mark - Add & Remove

- (void)addEnemy:(OGEntity *)enemy
{
    [self.mutableEnemies addObject:enemy];
}

- (void)removeEnemy:(OGEntity *)enemy
{
    [self.mutableEnemies removeObject:enemy];
}

- (void)addCoin:(OGEntity *)coin
{
    [self.mutableCoins addObject:coin];
}

- (void)removeCoin:(OGEntity *)coin
{
    [self.mutableCoins removeObject:coin];
}

- (void)addPortal:(OGEntity *)portal
{
    [self.mutablePortals addObject:portal];
}

- (void)removePortal:(OGEntity *)portal
{
    [self.mutablePortals removeObject:portal];
}

- (NSArray<OGEntity *> *)enemies
{
    return [[_mutableEnemies copy] autorelease];
}

- (NSArray<OGEntity *> *)coins
{
    return [[_mutableCoins copy] autorelease];
}

- (NSArray<OGEntity *> *)portals
{
    return [[_mutablePortals copy] autorelease];
}

#pragma mark - Collision Detection

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    OGSpriteNode *touchedBody = nil;
    OGContactType contactType = [self contactType:contact withBody:&touchedBody];
    
    if (contactType == kOGContactTypeGameOver)
    {
        if (!self.godMode)
        {
            [self.sceneDelegate gameSceneDidCallFinishGameWithScore:self.scoreController.score];
        }
    }
    else if (contactType == kOGContactTypePlayerDidGetCoin)
    {
        [self removeCoin:(OGEntity *) touchedBody.owner.entity];
        [touchedBody removeFromParent];
    }
    else if (contactType == kOGContactTypePlayerDidTouchPortal)
    {
        [self.sceneDelegate gameSceneDidCallFinishWithPortal:(OGEntity *) touchedBody.owner.entity];
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    OGSpriteNode *touchedBody = nil;
    OGContactType contactType = [self contactType:contact withBody:&touchedBody];
    
    if (contactType == kOGContactTypePlayerDidTouchObstacle)
    {
         [self.playerMovementControlComponent didChangeDirection];
    }
}

- (OGContactType)contactType:(SKPhysicsContact *)contact withBody:(SKNode **)body
{
    SKPhysicsBody *bodyA = nil;
    SKPhysicsBody *bodyB = nil;
    OGContactType result = kOGContactTypeNone;
    
    [self contact:contact toBodyA:&bodyA bodyB:&bodyB];
    
    if (bodyA.categoryBitMask == kOGCollisionBitMaskEnemy
        || bodyB.categoryBitMask == kOGCollisionBitMaskEnemy
        || bodyA.categoryBitMask == kOGCollisionBitMaskFlame
        || bodyB.categoryBitMask == kOGCollisionBitMaskFlame)
    {
        result = kOGContactTypeGameOver;
    }
    else if (bodyA.categoryBitMask == kOGCollisionBitMaskCoin)
    {
        *body = bodyA.node;
        result = kOGContactTypePlayerDidGetCoin;
    }
    else if (bodyB.categoryBitMask == kOGCollisionBitMaskCoin)
    {
        *body = bodyB.node;
        result = kOGContactTypePlayerDidGetCoin;
    }
    else if (bodyA.categoryBitMask == kOGCollisionBitMaskPortal)
    {
        *body = bodyA.node;
        result = kOGContactTypePlayerDidTouchPortal;
    }
    else if (bodyB.categoryBitMask == kOGCollisionBitMaskPortal)
    {
        *body = bodyB.node;
        result = kOGContactTypePlayerDidTouchPortal;
    }
    else if (bodyB.categoryBitMask == kOGCollisionBitMaskObstacle
             && bodyA.categoryBitMask == kOGCollisionBitMaskPlayer)
    {
        *body = bodyA.node;
        result = kOGContactTypePlayerDidTouchObstacle;
    }
    else if (bodyA.categoryBitMask == kOGCollisionBitMaskObstacle
             && bodyB.categoryBitMask == kOGCollisionBitMaskPlayer)
    {
        *body = bodyB.node;
        result = kOGContactTypePlayerDidTouchObstacle;
    }
    
    return result;
}

- (void)contact:(SKPhysicsContact *)contact toBodyA:(SKPhysicsBody **)bodyA bodyB:(SKPhysicsBody **)bodyB
{
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        *bodyA = contact.bodyA;
        *bodyB = contact.bodyB;
    }
    else
    {
        *bodyA = contact.bodyB;
        *bodyB = contact.bodyA;
    }
}

#pragma mark - Touches handling

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:location];
    
    if ([touchedNode.name isEqualToString:kOGPauseButtonName])
    {
        [self.sceneDelegate gameSceneDidCallPause];
    }
    else if ([touchedNode.name isEqualToString:kOGGameSceneResumeName])
    {
        [self.sceneDelegate gameSceneDidCallResume];
    }
    else if ([touchedNode.name isEqualToString:kOGGameSceneMenuName])
    {
        [self.sceneDelegate gameSceneDidCallMenu];
    }
    else if ([touchedNode.name isEqualToString:kOGGameSceneRestartName])
    {
        [self.sceneDelegate gameSceneDidCallRestart];
    }
    else
    {
        [self.playerMovementControlComponent touchBeganAtPoint:location];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    
    [self.playerMovementControlComponent touchMovedToPoint:touchLocation];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    
    [self.playerMovementControlComponent touchEndedAtPoint:touchLocation];
}

#pragma mark - Access Component Delegate Method

- (void)checkAccess
{
    if (self.scoreController.score.integerValue > 5)
    {
        for (OGEntity *portal in self.portals)
        {
            OGAccessComponent *accessComponent = (OGAccessComponent *) [portal componentForClass:[OGAccessComponent class]];
            [accessComponent grantAccessWithCompletionBlock:^()
             {
                 OGTransitionComponent *transitionBlock = (OGTransitionComponent *) [portal componentForClass:[OGTransitionComponent class]];
                 transitionBlock.closed = NO;
             }];
        }
    }
}

#pragma mark - Scene update

- (void)update:(NSTimeInterval)currentTime
{
    CGFloat playerPositionY = self.playerVisualComponent.spriteNode.position.y;
    CGFloat statusBarPositionY = self.frame.size.height - kOGGameSceneStatusBarYOffset;
    
    CGFloat distance = fabs(playerPositionY - statusBarPositionY);
    CGFloat statusBarHidingOffset = self.statusBar.size.height + kOGGameSceneStatusBarHidingOffset;
    
    if (distance > self.statusBarMinDistance && self.shouldShowStatusBar)
    {
        [self changeStatusBarLocationWithY:-statusBarHidingOffset];
    }
    else if (distance <= self.statusBarMinDistance && !self.shouldShowStatusBar)
    {
        [self changeStatusBarLocationWithY:statusBarHidingOffset];
    }
    
    for (OGEntity *portal in self.portals)
    {
        OGAccessComponent *accessComponent = (OGAccessComponent *) [portal componentForClass:[OGAccessComponent class]];
        [accessComponent updateWithDeltaTime:currentTime];
    }
}

- (CGFloat)statusBarMinDistance
{
    return self.statusBar.size.height * 2.0;
}


- (void)pause
{
    [self.scoreTimer pause];
    [self.coinsCreationTimer pause];
    
    self.physicsWorld.speed = kOGGameSceneSpeedStop;
    self.speed = kOGGameSceneSpeedStop;
    
    self.paused = YES;
}

- (void)resume
{
    [self.scoreTimer resume];
    [self.scoreTimer resume];
    
    self.physicsWorld.speed = kOGGameSceneSpeedDefault;
    self.speed = kOGGameSceneSpeedDefault;
    
    self.paused = NO;
}

- (void)changeStatusBarLocationWithY:(CGFloat)y
{
    SKAction *statusBarAction = [SKAction moveByX:0.0 y:y duration:kOGGameSceneStatusBarDuration];
    [self.statusBar runAction:statusBarAction];
    self.shouldShowStatusBar = !self.shouldShowStatusBar;
}

- (void)dealloc
{
    [_coinsCreationTimer stop];
    [_coinsCreationTimer release];
    
    [_scoreTimer stop];
    [_scoreTimer release];
    
    [_mutableEnemies release];
    [_player release];
    [_identifier release];
    [_mutablePortals release];
    [_sceneDelegate release];
    [_enemiesCount release];
    [_mutableCoins release];
    [_controlType release];
    [_pauseBarSprite release];
    
    [super dealloc];
}

@end
