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
CGFloat const kOGPlayerPlayerSpeed = 400.0;

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
        player.physicsBody.restitution = 1.0;
        player.physicsBody.friction = 0.0;
        
        player.physicsBody.velocity = [OGPlayer randomVelocityWithSpeed:kOGPlayerPlayerSpeed];
        //[player.physicsBody applyImpulse:CGVectorMake(25, 0)];
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

- (void)calculateAngle
{
    CGFloat deltaX = self.touchPoint.x - self.position.x;
    CGFloat deltaY = self.touchPoint.y - self.position.y;
    
    self.anglePlayer = atan2f(deltaY, deltaX);
}

- (void)changePlayerArcVelocity
{
//    NSLog(@"Vel: %f %f", self.physicsBody.velocity.dx, self.physicsBody.velocity.dy);
//    NSLog(@"Pos: %f %f", self.position.x, self.position.y);
    
//    CGVector pointVector = CGVectorMake(self.position.x - point.x, self.position.y - point.y);
//    
//    CGFloat scalarMultiplicationOfVectors = self.physicsBody.velocity.dx * pointVector.dx
//    + self.physicsBody.velocity.dy * pointVector.dy;
//    
//    CGFloat vectorsSquareRootMultiplication = (powf(powf(self.physicsBody.velocity.dx, 2.0) + powf(self.physicsBody.velocity.dy, 2.0), 0.5)) * (powf(powf(pointVector.dx, 2.0) + powf(pointVector.dy, 2.0), 0.5));
//    
//    CGFloat angle = (vectorsSquareRootMultiplication != 0) ? acosf(scalarMultiplicationOfVectors / vectorsSquareRootMultiplication) : 0.0;
//   
//    
//    if ((angle/M_PI) * 180 > 1.0)
//    {
//        CGFloat current_angle = atan2f(self.physicsBody.velocity.dy, self.physicsBody.velocity.dx);
//        self.physicsBody.velocity = CGVectorMake(kOGPlayerPlayerSpeed * -cosf(current_angle - angle),
//                                                 kOGPlayerPlayerSpeed * -sinf(current_angle - angle));
//        
//        //self.zRotation = (angle/M_PI) * 180;
//    }
   // CGFloat hypotenuse = powf(powf(point.x - self.position.x, 2.0) + powf(point.y - self.position.y, 2.0), 0.5);
    
//    CGFloat deltaX = self.touchPoint.x - self.position.x;
//    CGFloat deltaY = self.touchPoint.y - self.position.y;
//    
//    CGFloat angle = atan2f(deltaY, deltaX);
    
   // NSLog(@"%f %f", angle, atan2f(self.physicsBody.velocity.dx, self.physicsBody.velocity.dy));
    
    CGVector pointVector = CGVectorMake(self.position.x - self.touchPoint.x, self.position.y - self.touchPoint.y);
    NSLog(@"%f", self.physicsBody.velocity.dx/pointVector.dx - self.physicsBody.velocity.dy/pointVector.dy);
//    if ( powf( powf(deltaX, 2.0) + powf(deltaY, 2.0), 0.5 ) > 10.0 )
//    {
//        self.physicsBody.velocity = CGVectorMake(kOGPlayerPlayerSpeed * -cosf(angle/M_PI*18), kOGPlayerPlayerSpeed * - sinf(angle/M_PI*18));
//    }
//    else
//    {
//        self.physicsBody.velocity = CGVectorMake(kOGPlayerPlayerSpeed * -cosf(angle), kOGPlayerPlayerSpeed * - sinf(angle));
//        self.touch = NO;
//    }
    
   // if ( powf( powf(deltaX, 2.0) + powf(deltaY, 2.0), 0.5 ) > 1 )
    if (fabs(self.physicsBody.velocity.dx/pointVector.dx - self.physicsBody.velocity.dy/pointVector.dy) > 0.1)
    {
//        [self.physicsBody applyImpulse:CGVectorMake( cosf(self.anglePlayer), sinf(self.anglePlayer))];
    }
    else
    {
        [self calculateAngle];
        self.physicsBody.velocity = CGVectorMake(kOGPlayerPlayerSpeed * -cosf(self.anglePlayer), kOGPlayerPlayerSpeed * - sinf(self.anglePlayer));
        self.touch = NO;
    }
    
    //angle = (self.position.x > self.touchPoint.x) ?
    
   // NSLog(@"%f", fabs(angle - atan2f(self.physicsBody.velocity.dy, self.physicsBody.velocity.dx)));
    
//    if (fabs(angle/M_PI*180 - atan2f(self.physicsBody.velocity.dy, self.physicsBody.velocity.dx/M_PI*180)) > 18)
//    {
//        self.physicsBody.velocity = CGVectorMake(kOGPlayerPlayerSpeed + kOGPlayerPlayerSpeed * cosf(angle), kOGPlayerPlayerSpeed + kOGPlayerPlayerSpeed * sinf(angle));
    
//    }
//    else
//    {
//        self.physicsBody.velocity = CGVectorMake(kOGPlayerPlayerSpeed * -cosf(angle/M_PI), kOGPlayerPlayerSpeed * -sinf(angle));
//        self.touch = NO;
//    }
//    
  //  [self.physicsBody applyImpulse:CGVectorMake(-0.1, 0.1)];
    //self.touch = NO;
    //NSLog(@"Angle: %f", (angle/M_PI) * 180);
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