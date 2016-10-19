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
@property (nonatomic, retain) NSMutableArray<SKNode *> *detectionRediuses;

@end

@implementation OGLightningScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self)
    {
        _lightningPairs = [[NSMutableArray alloc] init];
        _detectionRediuses = [[NSMutableArray alloc] init];
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
        [self addPairDetectionRadiusToSpriteNode:((OGVisualComponent *) [enemy componentForClass:[OGVisualComponent class]]).spriteNode];
    }
    
    [self createPlayer];
    
}

- (void)addPairDetectionRadiusToSpriteNode:(OGSpriteNode *)spriteNode
{
    SKNode *pairDetectionRadius = [SKNode node];
    
    pairDetectionRadius.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:kOGLightningSceneRadiusForCreationPair];
    pairDetectionRadius.physicsBody.dynamic = YES;
    pairDetectionRadius.physicsBody.categoryBitMask = kOGLightningSceneRadiusCategoryBitMask;
    pairDetectionRadius.physicsBody.collisionBitMask = kOGLightningSceneRadiusCategoryBitMask;
    pairDetectionRadius.physicsBody.contactTestBitMask = kOGLightningSceneRadiusCategoryBitMask;
    pairDetectionRadius.physicsBody.usesPreciseCollisionDetection = YES;
    
    pairDetectionRadius.name = kOGLightningSceneRadiusNodeName;
    pairDetectionRadius.position = spriteNode.position;
    
    //    SKShapeNode *sh = [SKShapeNode shapeNodeWithCircleOfRadius:kOGLightningSceneRadiusForCreationPair];
    //    sh.strokeColor = [SKColor blackColor];
    //    [pairDetectionRadius addChild:sh];
    //
    [self.detectionRediuses addObject:pairDetectionRadius];
    [self addChild:pairDetectionRadius];
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
    if (contact.bodyA.categoryBitMask == kOGLightningSceneRadiusCategoryBitMask && contact.bodyB.categoryBitMask == kOGLightningSceneRadiusCategoryBitMask)
    {
        OGSpriteNode *nodeA = ((OGVisualComponent *)[self.enemies[[self.detectionRediuses indexOfObject:contact.bodyA.node]] componentForClass:[OGVisualComponent class]]).spriteNode;
        OGSpriteNode *nodeB = ((OGVisualComponent *)[self.enemies[[self.detectionRediuses indexOfObject:contact.bodyB.node]] componentForClass:[OGVisualComponent class]]).spriteNode;
        
        [self createPairBetweenSpriteNodeA:nodeA spriteNodeB:nodeB];
    }
    else
    {
        [super didBeginContact:contact];
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    if (contact.bodyA.categoryBitMask == kOGLightningSceneRadiusCategoryBitMask && contact.bodyB.categoryBitMask == kOGLightningSceneRadiusCategoryBitMask)
    {
        OGSpriteNode *nodeA = ((OGVisualComponent *)[self.enemies[[self.detectionRediuses indexOfObject:contact.bodyA.node]] componentForClass:[OGVisualComponent class]]).spriteNode;
        OGSpriteNode *nodeB = ((OGVisualComponent *)[self.enemies[[self.detectionRediuses indexOfObject:contact.bodyB.node]] componentForClass:[OGVisualComponent class]]).spriteNode;
        
        [self removePairBetweenSpriteNodeA:nodeA spriteNodeB:nodeB];
    }
    else
    {
        //        [super didEndContact:contact];
    }
}


- (void)createPairBetweenSpriteNodeA:(OGSpriteNode *)spriteNodeA spriteNodeB:(OGSpriteNode *)spriteNodeB
{
    __block BOOL isExist = NO;
    [self.lightningPairs enumerateObjectsUsingBlock:^(OGLightningScenePair * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if ((obj.spriteNodeA == spriteNodeA && obj.spriteNodeB == spriteNodeB)
             || (obj.spriteNodeA == spriteNodeB && obj.spriteNodeB == spriteNodeA))
         {
             isExist = YES;
             *stop = YES;
         }
     }];
    
    if (!isExist)
    {
        OGLightningScenePair *newPair = [OGLightningScenePair pairWithSpriteNodeA:spriteNodeA spriteNodeB:spriteNodeB];
        [self.lightningPairs addObject:newPair];
        [self addChild:newPair];
    }
}

- (void)removePairBetweenSpriteNodeA:(OGSpriteNode *)spriteNodeA spriteNodeB:(OGSpriteNode *)spriteNodeB
{
    __block NSUInteger index = NSNotFound;
    
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
    
    [self.detectionRediuses enumerateObjectsUsingBlock:^(SKNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         obj.position = ((OGVisualComponent *)[self.enemies[idx] componentForClass:[OGVisualComponent class]]).spriteNode.position;
     }];
    
    [super update:currentTime];
}

- (void)dealloc
{
    [_lightningPairs release];
    [_detectionRediuses  release];
    
    [super dealloc];
}

@end
