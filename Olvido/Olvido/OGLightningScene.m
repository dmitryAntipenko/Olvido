//
//  OGLightingScene.m
//  Olvido
//
//  Created by Алексей Подолян on 10/19/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLightningScene.h"
#import "OGLightningScenePair.h"

CGFloat const kOGLightningSceneRadiusForCreationPair = 150;
CGFloat const kOGLightningSceneRadiusCategoryBitMask = 0x01 << 7;
NSString *const kOGLightningSceneRadiusNodeName = @"radiusForDetectionPair";

@interface OGLightningScene ()

@property (nonatomic, retain) NSMutableArray<OGLightningScenePair *> *lightningPairs;

@end

@implementation OGLightningScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self)
    {
        _lightningPairs = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)createSceneContents
{
    [super createSceneContents];
    
    self.backgroundColor = [SKColor gameGreen];
    
    [self addChild:[self createBackgroundBorderWithColor:[SKColor gameBlack]]];
    
    [self createEnemies];
    
    for (OGEntity *enemy in self.enemies)
    {
        ((OGVisualComponent *) [enemy componentForClass:[OGVisualComponent class]]).color = [SKColor gameDarkGreen];
    }
    
    [self createPlayer];
    
}

- (void)addPairDetectionRadiusToSpriteNode:(OGSpriteNode *)spriteNode
{
    SKNode *pairDetectionRadius = [SKNode node];
    
    pairDetectionRadius.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:kOGLightningSceneRadiusForCreationPair];
    pairDetectionRadius.physicsBody.dynamic = NO;
    pairDetectionRadius.physicsBody.categoryBitMask = kOGLightningSceneRadiusCategoryBitMask;
    pairDetectionRadius.physicsBody.collisionBitMask = kOGCollisionBitMaskDefault;
    pairDetectionRadius.physicsBody.contactTestBitMask = kOGLightningSceneRadiusCategoryBitMask;
    
    pairDetectionRadius.name = kOGLightningSceneRadiusNodeName;
    
    [spriteNode addChild:pairDetectionRadius];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKNode *nodeA = contact.bodyA.node;
    SKNode *nodeB = contact.bodyB.node;
    
    if ([nodeA.name isEqualToString:kOGLightningSceneRadiusNodeName] && [nodeB.name isEqualToString:kOGLightningSceneRadiusNodeName])
    {
        [self createPairBetweenSpriteNodeA:(OGSpriteNode *)nodeA.parent psriteNodeB:(OGSpriteNode *)nodeB.parent];
    }
    else
    {
        [super didBeginContact:contact];
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    SKNode *nodeA = contact.bodyA.node;
    SKNode *nodeB = contact.bodyB.node;
    
    if ([nodeA.name isEqualToString:kOGLightningSceneRadiusNodeName] && [nodeB.name isEqualToString:kOGLightningSceneRadiusNodeName])
    {
        [self removePairBetweenSpriteNodeA:(OGSpriteNode *)nodeA.parent psriteNodeB:(OGSpriteNode *)nodeB.parent];
    }
    else
    {
        [super didEndContact:contact];
    }
}

- (void)dealloc
{
    [_lightningPairs release];
    
    [super dealloc];
}

- (void)createPairBetweenSpriteNodeA:(OGSpriteNode *)spriteNodeA psriteNodeB:(OGSpriteNode *)spriteNodeB
{
    OGLightningScenePair *newPair = [OGLightningScenePair pairWithSpriteNodeA:spriteNodeA spriteNodeB:spriteNodeB];
    [self.lightningPairs addObject:newPair];
    [self addChild:newPair];
    
}

- (void)removePairBetweenSpriteNodeA:(OGSpriteNode *)spriteNodeA psriteNodeB:(OGSpriteNode *)spriteNodeB
{
    __block NSUInteger index = 0;
    
    [self.lightningPairs enumerateObjectsUsingBlock:^(OGLightningScenePair * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if ((obj.spriteNodeA == spriteNodeA && obj.spriteNodeB == spriteNodeB)
             || (obj.spriteNodeA == spriteNodeB && obj.spriteNodeB == spriteNodeA))
         {
             index = idx;
             *stop = YES;
         }
     }];
    
    if (index < self.lightningPairs.count)
    {
        [self.lightningPairs[index] removeFromParent];
        [self.lightningPairs removeObjectAtIndex:index];
    }
}

- (void)update:(NSTimeInterval)currentTime
{
    for (OGLightningScenePair *pair in self.lightningPairs)
    {
        [pair update];
    }
    
    [super update:currentTime];
}

@end
