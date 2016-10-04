//
//  OGPlayer.m
//  Olvido
//
//  Created by Александр Песоцкий on 9/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayer.h"
#import "OGEnemy.h"

NSString *const kOGGameScenePlayerImageName = @"PlayerBall";
NSString *const kOGPlayerPlayerName = @"player";
CGFloat const kOGPlayerPlayerRadius = 16.0;
CGFloat const kOGPlayerPlayerSpeed = 300.0;

@implementation OGPlayer

+ (instancetype)playerWithImageName:(NSString *)imageName point:(CGPoint)point
{
    OGPlayer *player = [[OGPlayer alloc] initWithImageNamed:imageName];
    
    if (player)
    {
        player.name = kOGPlayerPlayerName;
        player.size = CGSizeMake(kOGPlayerPlayerRadius * 2.0, kOGPlayerPlayerRadius * 2.0);
        player.position = point;
        player.lastPosition = point;
        
        player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:kOGPlayerPlayerRadius];
        player.physicsBody.dynamic = YES;
        player.physicsBody.linearDamping = 0.0;
        player.physicsBody.angularDamping = 0.0;
        
        player.physicsBody.friction = 0.0;
        player.physicsBody.restitution = 1.0;
        
        player.physicsBody.categoryBitMask = 0x1 << 1;
        player.physicsBody.collisionBitMask = 0x1 << 0;
        player.physicsBody.contactTestBitMask = 0x1 << 0;
        
        player.physicsBody.usesPreciseCollisionDetection = YES;
        
        SKAction *invulnerability = [SKAction waitForDuration:kOGInvulnerabilityRepeatCount * kOGInvulnerabilityBlinkingTimeDuration * 2.0];
        [player runAction:invulnerability completion:^
        {
            player.physicsBody.contactTestBitMask = player.physicsBody.contactTestBitMask | 0x1 << 2;
        }];
        
        player.physicsBody.restitution = 1.0;
        player.physicsBody.friction = 0.0;
        
//        player.physicsBody.velocity = [OGPlayer randomVelocityWithSpeed:kOGPlayerPlayerSpeed]; //this needs for swipe control
    }

    return [player autorelease];
}

+ (instancetype)playerWithPoint:(CGPoint)point
{
    return [OGPlayer playerWithImageName:kOGGameScenePlayerImageName point:point];
}

- (void)changePlayerTextureWithImageName:(NSString *)imageName
{
    SKTexture *texture = [SKTexture textureWithImageNamed:imageName];
    
    if (texture)
    {
        self.texture = texture;
    }
}

- (BOOL)isPointInPlayerWithPoint:(CGPoint)point
{
    BOOL result = NO;
    
    if (powf((point.x - self.position.x), 2) + powf((point.y - self.position.y), 2) < powf(kOGPlayerPlayerRadius, 2))
    {
        result = YES;
    }
    
    return result;
}

- (void)changePlayerVelocityWithPoint:(CGPoint)point
{
    CGFloat speedVec = powf(powf(point.x - self.position.x, 2.0) + powf(point.y - self.position.y, 2.0), 0.5);
    CGFloat coef = kOGPlayerPlayerSpeed / speedVec;
    
    self.physicsBody.velocity = CGVectorMake((point.x - self.position.x) * coef, (point.y - self.position.y) * coef);
}

+ (CGVector)randomVelocityWithSpeed:(CGFloat)speed
{
    CGFloat x = ((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * speed;
    CGFloat y = powf((powf(speed, 2.0) - powf(x, 2.0)), 0.5);
    
    x = (arc4random() % 2 == 0) ? (x * (-1.0)) : x;
    y = (arc4random() % 2 == 0) ? (y * (-1.0)) : y;
    
    return CGVectorMake(x, y);
}


@end