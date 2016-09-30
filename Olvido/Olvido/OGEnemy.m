//
//  OGEnemy.m
//  Olvido
//
//  Created by Алексей Подолян on 9/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemy.h"

NSString *const kOGEnemyNodeName = @"Enemy Node";
NSString *const kOGEnemyTextureName = @"EnemyTexture.png";
NSString *const kOGEnemyTextureInvulnerableName = @"EnemyTexture_invulnerable.png";
CGFloat const kOGenemySize = 64;
CGFloat const kOGInvulnerabilityRepeatCount = 4;
CGFloat const kOGInvulnerabilityBlinkingTimeDuration = 0.5;
CGFloat const kOGEnemyVelocity = 20;
uint32_t const kOGEnemyCategoryBitMask = 0x1 << 2;

@implementation OGEnemy

+ (nullable instancetype)enemy
{
    OGEnemy *enemy = nil;
    
    SKTexture *enemyTexture = [SKTexture textureWithImageNamed:kOGEnemyTextureName];
    SKTexture *enemyInvulnerableTexture = [SKTexture textureWithImageNamed:kOGEnemyTextureInvulnerableName];
    
    if (enemyTexture && enemyInvulnerableTexture)
    {
        CGSize size = CGSizeMake(kOGenemySize, kOGenemySize);
        enemy = [self spriteNodeWithTexture:enemyInvulnerableTexture size:size];
        
        if (enemy)
        {
            enemy.name = kOGEnemyNodeName;
            enemy.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(enemy.size.width / 2.0)];
            enemy.physicsBody.linearDamping = 0.0;
            enemy.physicsBody.angularDamping = 0.0;
            enemy.physicsBody.affectedByGravity = NO;
            
            enemy.physicsBody.categoryBitMask = kOGEnemyCategoryBitMask;
            enemy.physicsBody.collisionBitMask = 0x0;
            
            SKAction *blink = [SKAction animateWithTextures:@[
                                                              enemyInvulnerableTexture,
                                                              enemyTexture
                                                              ]
                                               timePerFrame:kOGInvulnerabilityBlinkingTimeDuration];
            
            SKAction *repeatBlinking = [SKAction repeatAction:blink count:kOGInvulnerabilityRepeatCount];
            
            SKAction *invulnerability = [SKAction sequence:@[
                                                             repeatBlinking,
                                                             [SKAction setTexture:enemyTexture]
                                                             ]];
            
            [enemy runAction:invulnerability completion:^{
                
            }];
        }
    }
    return enemy;
}

@end
