//
//  OGPlayer.m
//  Olvido
//
//  Created by Александр Песоцкий on 9/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayer.h"

NSString *const kOGGameScenePlayerImageName = @"PlayerBall";
NSString *const kOGPlayerPlayerName = @"player";
CGFloat const kOGPlayerPlayerRadius = 16.0;

@implementation OGPlayer

+ (instancetype)playerWithImageName:(NSString *)imageName point:(CGPoint)point
{
    OGPlayer *player = [[OGPlayer alloc] initWithImageNamed:imageName];
    
    if (player)
    {
        player.name = kOGPlayerPlayerName;
        player.size = CGSizeMake(kOGPlayerPlayerRadius * 2.0, kOGPlayerPlayerRadius * 2.0);
        player.position = point;
        
        player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(kOGPlayerPlayerRadius)];
        player.physicsBody.dynamic = YES;
        player.physicsBody.linearDamping = 0.0;
        player.physicsBody.angularDamping = 0.0;
        player.physicsBody.categoryBitMask = 0x1 << 1;
        player.physicsBody.collisionBitMask = 0x1 << 0;
        
        player.physicsBody.usesPreciseCollisionDetection = YES;
        
        SKAction *invulnerability = [SKAction waitForDuration:3.0];
        [player runAction:invulnerability completion:^{
            player.physicsBody.contactTestBitMask = 0x1 << 2;
        }];
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

@end