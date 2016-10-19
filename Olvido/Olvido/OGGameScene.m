//
//  OGGameScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene.h"

@interface OGGameScene ()

@property (nonatomic, retain) NSMutableArray<OGEntity *> *mutableEnemies;
@property (nonatomic, retain) NSMutableArray<OGEntity *> *mutablePortals;
@property (nonatomic, retain) NSMutableArray<OGEntity *> *mutableCoins;

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
        /* temporary code */
        if (!self.godMode)
        {
            NSLog(@"Game Over");
        }
        /* temporary code */
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

- (void)dealloc
{
    [_mutableEnemies release];
    [_player release];
    [_identifier release];
    [_mutablePortals release];
    [_sceneDelegate release];
    [_enemiesCount release];
    [_mutableCoins release];
    [_controlType release];
    
    [super dealloc];
}

@end
