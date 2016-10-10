//
//  OGEnemyNode.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyNode.h"
#import "OGCollisionBitMask.h"
#import "OGConstants.h"
#import "SKColor+OGConstantColors.h"

NSString *const kOGEnemyNodeTextureName = @"EnemyBall";

CGFloat const kOGEnemyNodeInvulnerabilityRepeatCount = 4;
CGFloat const kOGEnemyNodeInvulnerabilityBlinkingTimeDuration = 0.5;
CGFloat const kOGEnemyNodeVelocity = 10;

@implementation OGEnemyNode

+ (instancetype)enemyNode
{
    OGEnemyNode *enemyNode = [[OGEnemyNode alloc] initWithColor:[SKColor blackColor]];
    
    SKTexture *enemyNodeTexture = [SKTexture textureWithImageNamed:kOGEnemyNodeTextureName];
    
    if (enemyNodeTexture)
    {
        CGSize size = CGSizeMake(enemyNode.radius * 2.0,
                                 enemyNode.radius * 2.0);
        
        enemyNode.appearance = [SKSpriteNode spriteNodeWithTexture:enemyNodeTexture size:size];
        
        if (enemyNode.appearance)
        {
            enemyNode.name = kOGEnemyNodeName;
            
            [enemyNode addChild:enemyNode.appearance];
            
            enemyNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:enemyNode.radius];
            enemyNode.physicsBody.linearDamping = 0.0;
            enemyNode.physicsBody.angularDamping = 0.0;
            enemyNode.physicsBody.friction = 0.0;
            enemyNode.physicsBody.restitution = 1.0;
            
            enemyNode.physicsBody.categoryBitMask = kOGCollisionBitMaskEnemy;
            enemyNode.physicsBody.collisionBitMask = kOGCollisionBitMaskObstacle;
            enemyNode.physicsBody.contactTestBitMask = kOGCollisionBitMaskDefault;
            
            SKAction *invulnerabilityAction = [SKAction sequence:@[
                                                                   [SKAction colorizeWithColor:[SKColor backgroundLightGrayColor]
                                                                              colorBlendFactor:1.0
                                                                                      duration:kOGEnemyNodeInvulnerabilityBlinkingTimeDuration / 2.0],
                                                                   [SKAction colorizeWithColor:[SKColor gameBlack]
                                                                        colorBlendFactor:1.0
                                                                                duration:kOGEnemyNodeInvulnerabilityBlinkingTimeDuration / 2.0]
                                                             ]];
            
            SKAction *repeatAction = [SKAction repeatAction:invulnerabilityAction count:kOGEnemyNodeInvulnerabilityRepeatCount];
            
            [enemyNode.appearance runAction:repeatAction];
        }
    }
    
    return [enemyNode autorelease];
}

- (void)startWithPoint:(CGPoint)point
{
    if (self.parent)
    {
        self.position = point;
        CGVector vector = ogRanomVector(kOGEnemyNodeVelocity);
        [self.physicsBody applyImpulse:vector];
    }
}

@end
