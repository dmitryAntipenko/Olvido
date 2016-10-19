//
//  OGLightingScene.m
//  Olvido
//
//  Created by Алексей Подолян on 10/19/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLightingScene.h"

CGFloat const kOGLightingSceneMaxDistanceBetweenPairNodes = 300;

@interface OGLightingScene ()

@property (nonatomic, retain) NSMutableArray<OGLightingScene *> *lightingPairs;

@end

@implementation OGLightingScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self)
    {
        _lightingPairs = [[NSMutableArray alloc] init];
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
    [super didBeginContact:contact];
}

- (void)checkDestinationBetweenEnemies
{
    for (NSUInteger i = 0; i < self.enemies.count; i++)
    {
        OGSpriteNode *currentEnemySprite = ((OGVisualComponent *)[self.enemies[i] componentForClass:[OGVisualComponent class]]).spriteNode;
        
        for (NSUInteger j = i + 1; j < self.enemies.count; j++)
        {
            OGSpriteNode *temporaryEnemySprite = ((OGVisualComponent *)[self.enemies[j] componentForClass:[OGVisualComponent class]]).spriteNode;
            
            if ()
        }
    }
}

- (CGFloat)distanceBetweenEnemySpriteNodeA:(OGSpriteNode *)enemySpriteNodeA enemySpriteNodeB:(OGSpriteNode *)enemySpriteNodeB
{
    return pow(pow(enemySpriteNodeA.position.x - enemySpriteNodeB.position.x, 2) + pow(enemySpriteNodeA.position.y - enemySpriteNodeB.position.y, 2), 0.5);
}

- (void)dealloc
{
    [_lightingPairs release];
    
    [super dealloc];
}

- (BOOL)approachingSpriteNodeA:(OGSpriteNode *)spriteNodeA spriteNodeB:(OGSpriteNode *)spriteNodeB
{
    CGFloat distanceBeforeAddingVelocityVectors = pow(pow(spriteNodeA.position.x - spriteNodeB.position.x, 2)
                                                      + pow(spriteNodeA.position.y - spriteNodeB.position.y, 2), 0.5);
    
    CGVector movementVectorA = spriteNodeA.physicsBody.velocity;
    CGVector movementVectorB = spriteNodeB.physicsBody.velocity;
    
    CGFloat distanceAfterAddingVelocityVectors = pow(pow((spriteNodeA.position.x + movementVectorA.dx) - (spriteNodeB.position.x + movementVectorB.dx), 2)
                                                     + pow((spriteNodeA.position.y + movementVectorA.dy) - (spriteNodeB.position.y + movementVectorB.dy), 2), 0.5);
    
    return distanceAfterAddingVelocityVectors <= distanceBeforeAddingVelocityVectors;
}

@end


@interface OGLightingScenePair : NSObject

+ (instancetype)pairWithSpriteNodeA:(OGSpriteNode *)spriteNodeA spriteNodeB:(OGSpriteNode *)spriteNodeB;

@property (nonatomic, assign, readonly) OGSpriteNode *spriteNodeA;
@property (nonatomic, assign, readonly) OGSpriteNode *spriteNodeB;

@end

@implementation OGLightingScenePair

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
