//
//  OGEnemyNode.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyNode.h"

NSString *const kOGEnemyNodeTextureName = @"EnemyBall";
NSString *const kOGEnemyNodeTextureInvulnerableName = @"PlayerBall";

CGFloat const kOGEnemyNodeInvulnerabilityRepeatCount = 4;
CGFloat const kOGEnemyNodeInvulnerabilityBlinkingTimeDuration = 0.5;
CGFloat const kOGEnemyNodeVelocity = 10;
uint32_t const kOGEnemyNodeCategoryBitMask = 0x1 << 2;

@implementation OGEnemyNode

+ (instancetype)enemyNode
{
    OGEnemyNode *enemyNode = [[OGEnemyNode alloc] initWithColor:[SKColor blackColor]];
    
    SKTexture *enemyNodeTexture = [SKTexture textureWithImageNamed:kOGEnemyNodeTextureName];
    SKTexture *enemyNodeInvulnerableTexture = [SKTexture textureWithImageNamed:kOGEnemyNodeTextureInvulnerableName];
    
    if (enemyNodeTexture && enemyNodeInvulnerableTexture)
    {
        CGSize size = CGSizeMake(enemyNode.radius * 2.0,
                                 enemyNode.radius * 2.0);
        
        enemyNode.appearance = [SKSpriteNode spriteNodeWithTexture:enemyNodeInvulnerableTexture size:size];
        
        if (enemyNode.appearance)
        {
            [enemyNode addChild:enemyNode.appearance];
            
            enemyNode.appearance.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:enemyNode.radius];
            enemyNode.appearance.physicsBody.linearDamping = 0.0;
            enemyNode.appearance.physicsBody.angularDamping = 0.0;
            enemyNode.appearance.physicsBody.friction = 0.0;
            enemyNode.appearance.physicsBody.restitution = 1.0;
            
            enemyNode.appearance.physicsBody.categoryBitMask = kOGEnemyNodeCategoryBitMask;
            enemyNode.appearance.physicsBody.collisionBitMask = 0x1 << 0;
            enemyNode.appearance.physicsBody.contactTestBitMask = 0x0;
            
            NSArray *texturesAnamations = @[enemyNodeInvulnerableTexture,
                                            enemyNodeTexture];
            
            SKAction *blink = [SKAction animateWithTextures:texturesAnamations
                                               timePerFrame:kOGEnemyNodeInvulnerabilityBlinkingTimeDuration];
            
            SKAction *repeatBlinking = [SKAction repeatAction:blink count:kOGEnemyNodeInvulnerabilityRepeatCount];
            
            
            SKAction *invulnerability = [SKAction sequence:@[
                                                             repeatBlinking,
                                                             [SKAction setTexture:enemyNodeTexture]
                                                             ]];
            
            [enemyNode.appearance runAction:invulnerability];
        }
    }
    
    
    return [enemyNode autorelease];
}

- (void)startWithPoint:(CGPoint)point
{
    if (self.parent)
    {
        self.appearance.position = point;
        CGVector vector = ogRanomVector(kOGEnemyNodeVelocity);
        [self.appearance.physicsBody applyImpulse:vector];
    }
}

@end
