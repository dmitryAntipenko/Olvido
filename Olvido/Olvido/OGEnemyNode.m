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
CGFloat const kOGEnemyNodeSpeed = 300;

@interface OGEnemyNode ()

@property (nonatomic, assign) CGFloat currentSpeed;

@end

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
                                                                                      duration:kOGPlayerNodeInvulnerabilityBlinkingTimeDuration],
                                                                   [SKAction colorizeWithColor:[SKColor gameBlack]
                                                                        colorBlendFactor:1.0
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
        CGVector vector = ogRanomVector(kOGEnemyNodeSpeed * self.physicsBody.mass);
        
        [self.physicsBody applyImpulse:vector];
    }
}

- (void)changeSpeedWithCoefficient:(CGFloat)speedCoefficient;
{
    self.currentSpeed = kOGEnemyNodeSpeed * speedCoefficient;
    
    CGVector movementVector = self.physicsBody.velocity;
    CGFloat movementVectorModule = pow(pow(movementVector.dx, 2) + pow(movementVector.dy, 2), 0.5);
    
    CGVector impulse = CGVectorMake(movementVector.dx / movementVectorModule * self.currentSpeed * self.physicsBody.mass,
                                    movementVector.dy / movementVectorModule * self.currentSpeed * self.physicsBody.mass);
    
    self.physicsBody.velocity = CGVectorMake(0.0, 0.0);
    [self.physicsBody applyImpulse:impulse];
}

@end
