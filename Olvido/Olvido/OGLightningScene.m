//
//  OGLightingScene.m
//  Olvido
//
//  Created by Алексей Подолян on 10/19/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLightningScene.h"

CGFloat const kOGLightningSceneRadiusForCreationPair = 150;
CGFloat const kOGLightningSceneRadiusCategoryBitMask = 0x01 << 7;
NSString *const kOGLightningSceneRadiusNodeName = @"radiusForDetectionPair";
NSString *const kOGLightningSceneParticleFileName = @"Lightning";
NSString *const kOGLightningSceneParticleFileExtension = @"sks";

@interface OGLightningScene ()

@property (nonatomic, retain) NSMutableArray<OGLightningScene *> *lightningPairs;
@property (nonatomic, retain) NSString *lightningParticleFilePath;

@end

@implementation OGLightningScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self)
    {
        _lightningPairs = [[NSMutableArray alloc] init];
        _lightningParticleFilePath =[[NSBundle mainBundle] pathForResource:kOGLightningSceneParticleFileName
                                                                      ofType:kOGLightningSceneParticleFileExtension];
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
    [_lightningParticleFilePath release];
    
    [super dealloc];
}

- (void)createPairBetweenSpriteNodeA:(OGSpriteNode *)spriteNode psriteNodeB:(OGSpriteNode *)spriteNodeB
{
    SKEmitterNode *lightningEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:self.lightningParticleFilePath];
    lightningEmitter.
    
}

- (void)removePairBetweenSpriteNodeA:(OGSpriteNode *)spriteNode psriteNodeB:(OGSpriteNode *)spriteNodeB
{
    
}

@end


@interface OGLightningScenePair : NSObject

+ (instancetype)pairWithSpriteNodeA:(OGSpriteNode *)spriteNodeA spriteNodeB:(OGSpriteNode *)spriteNodeB;

@property (nonatomic, assign, readonly) OGSpriteNode *spriteNodeA;
@property (nonatomic, assign, readonly) OGSpriteNode *spriteNodeB;

@end

@implementation OGLightningScenePair

+ (instancetype)pairWithSpriteNodeA:(OGSpriteNode *)spriteNodeA spriteNodeB:(OGSpriteNode *)spriteNodeB
{
    return [[[self alloc] initWithSpriteNodeA:spriteNodeA spriteNodeB:spriteNodeB] autorelease];
}

- (instancetype)initWithSpriteNodeA:(OGSpriteNode *)spriteNodeA spriteNodeB:(OGSpriteNode *)spriteNodeB
{
    self = [self init];
    
    if (self)
    {
        _spriteNodeA = spriteNodeA;
        _spriteNodeB = spriteNodeB;
    }
    
    return self;
}

@end
