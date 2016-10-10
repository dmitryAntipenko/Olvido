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

CGFloat const kOGEnemyNodeVelocity = 10;
CGFloat const kOGEnemyNodeLinearDamping = 0.0;
CGFloat const kOGEnemyNodeAngularDamping = 0.0;
CGFloat const kOGEnemyNodeFriction = 0.0;
CGFloat const kOGEnemyNodeRestitution = 1.0;

CGFloat const kOGPlayerNodeInvulnerabilityBlinkingColorBlendFactor = 1.0;

@implementation OGEnemyNode

+ (instancetype)enemyNode
{
    OGEnemyNode *enemyNode = [[OGEnemyNode alloc] initWithColor:[SKColor blackColor]];
    
    SKTexture *enemyNodeTexture = [SKTexture textureWithImageNamed:kOGEnemyNodeTextureName];
    
    if (enemyNodeTexture)
    {
        CGSize size = CGSizeMake(enemyNode.diameter,
                                 enemyNode.diameter);
        
        enemyNode.appearance = [SKSpriteNode spriteNodeWithTexture:enemyNodeTexture size:size];
        
        if (enemyNode.appearance)
        {
            enemyNode.name = kOGEnemyNodeName;
            
            [enemyNode addChild:enemyNode.appearance];
            
            enemyNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:enemyNode.radius];
            enemyNode.physicsBody.linearDamping = kOGEnemyNodeLinearDamping;
            enemyNode.physicsBody.angularDamping = kOGEnemyNodeAngularDamping;
            enemyNode.physicsBody.friction = kOGEnemyNodeFriction;
            enemyNode.physicsBody.restitution = kOGEnemyNodeRestitution;
            
            enemyNode.physicsBody.categoryBitMask = kOGCollisionBitMaskEnemy;
            enemyNode.physicsBody.collisionBitMask = kOGCollisionBitMaskObstacle;
            enemyNode.physicsBody.contactTestBitMask = kOGCollisionBitMaskDefault;
            
            SKAction *invulnerabilityAction = [SKAction sequence:@[
                                                                   [SKAction colorizeWithColor:[SKColor backgroundLightGrayColor]
                                                                              colorBlendFactor:kOGPlayerNodeInvulnerabilityBlinkingColorBlendFactor
                                                                                      duration:kOGPlayerNodeInvulnerabilityBlinkingTimeDuration],
                                                                   [SKAction colorizeWithColor:[SKColor gameBlack]
                                                                        colorBlendFactor:kOGPlayerNodeInvulnerabilityBlinkingColorBlendFactor
                                                                                duration:kOGPlayerNodeInvulnerabilityBlinkingTimeDuration]
                                                             ]];
            
            SKAction *repeatAction = [SKAction repeatAction:invulnerabilityAction count:kOGPlayerNodeInvulnerabilityRepeatCount];
            
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
