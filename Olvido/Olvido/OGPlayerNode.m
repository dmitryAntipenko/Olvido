//
//  OGPlayer.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerNode.h"
#import "SKColor+OGConstantColors.h"

CGFloat const kOGPlayerNodeBorderLineWidth = 4.0;
CGFloat const kOGPlayerNodeInvulnerabilityRepeatCount = 4.0;
CGFloat const kOGPlayerNodeInvulnerabilityBlinkingTimeDuration = 0.2;
NSString *const kOGPlayerNodeSpriteImageName = @"PlayerBall";
CGFloat const kOGPlayerPlayerSpeed = 300.0;
NSUInteger const kOGPlayerDefaultPreviousPositionsBufferSize = 5;
NSString *const kOGMovePlayerToPointActionKey = @"movePlayerToPointActionKey";

@interface OGPlayerNode ()

@property (nonatomic, retain) NSMutableArray<NSValue *> *previousPositionsBuffer;
@property (nonatomic, readonly) CGVector movementVector;

@end

@implementation OGPlayerNode

+ (instancetype)playerNodeWithColor:(SKColor *)color
{
    OGPlayerNode *playerNode = [[OGPlayerNode alloc] initWithColor:color];
    
    if (playerNode)
    {
        playerNode.appearance = [SKSpriteNode spriteNodeWithImageNamed:kOGPlayerNodeSpriteImageName];
        playerNode.appearance.size = CGSizeMake(playerNode.radius * 2.0, playerNode.radius * 2.0);
        playerNode.appearance.color = [SKColor blackColor];
        playerNode.appearance.colorBlendFactor = 1.0;
        [playerNode addChild:playerNode.appearance];
        
        playerNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:kOGBasicGameNodeRadius];
        playerNode.physicsBody.dynamic = YES;
        playerNode.physicsBody.linearDamping = 0.0;
        playerNode.physicsBody.angularDamping = 0.0;
        
        playerNode.physicsBody.friction = 0.0;
        playerNode.physicsBody.restitution = 1.0;
        
        playerNode.physicsBody.categoryBitMask = 0x1 << 1;
        playerNode.physicsBody.collisionBitMask = 0x1 << 0;
        playerNode.physicsBody.contactTestBitMask = 0x1 << 0;
        
        playerNode.physicsBody.usesPreciseCollisionDetection = YES;
        
        SKAction *invulnerability = [SKAction waitForDuration:kOGPlayerNodeInvulnerabilityRepeatCount * kOGPlayerNodeInvulnerabilityBlinkingTimeDuration * 2.0];
        
        [playerNode runAction:invulnerability completion:^
         {
             playerNode.physicsBody.contactTestBitMask = playerNode.physicsBody.contactTestBitMask | 0x1 << 2;
         }];
    }
    
    return  [playerNode autorelease];
}

- (void)setColor:(SKColor *)color
{
    self.appearance.color = color;
}

- (void)createPreviousPositionsBuffferWithStartPoint:(CGPoint)startPoint
{
    NSMutableArray *result = [NSMutableArray array];
    
    for (int i = 0; i < kOGPlayerDefaultPreviousPositionsBufferSize; i++)
    {
        NSValue *value = [NSValue valueWithCGPoint:startPoint];
        [result addObject:value];
    }
    
    self.previousPositionsBuffer = result;
}

- (CGVector)movementVector
{
    if (!self.previousPositionsBuffer)
    {
        [self createPreviousPositionsBuffferWithStartPoint:self.position];
    }
    
    CGVector result;
    if (self.previousPositionsBuffer && self.previousPositionsBuffer.count > 1)
    {
        NSInteger i = 0;
        while ((i < self.previousPositionsBuffer.count - 1)
               && [self.previousPositionsBuffer[0] isEqualToValue:self.previousPositionsBuffer[++i]]);
        
        CGPoint point1 = self.previousPositionsBuffer[0].CGPointValue;
        CGPoint point2 = self.previousPositionsBuffer[i].CGPointValue;
        
        result = CGVectorMake(point1.x - point2.x, point1.y - point2.y);
    }
    return result;
}

- (void)moveToPoint:(CGPoint)point
{
    self.physicsBody.velocity = CGVectorMake(0, 0);
    [self removeActionForKey:kOGMovePlayerToPointActionKey];
    
    CGVector displacementVector = CGVectorMake(point.x - self.position.x,
                                               point.y - self.position.y);
    
    CGVector movementVector = self.movementVector;
    
    if (movementVector.dx == 0.0 && movementVector.dy == 0.0)
    {
        
        CGFloat l = pow(pow(displacementVector.dx, 2) + pow(displacementVector.dy, 2), 0.5);
        
        CGFloat x = displacementVector.dx * kOGPlayerPlayerSpeed / l * self.physicsBody.mass;
        CGFloat y = displacementVector.dy * kOGPlayerPlayerSpeed / l * self.physicsBody.mass;
        
        [self.physicsBody applyImpulse:CGVectorMake(x, y)];
    }
    else
    {
        CGFloat v = pow(pow(movementVector.dx, 2) + pow(movementVector.dy, 2), 0.5);
        
        CGFloat l = pow(pow(displacementVector.dx, 2) + pow(displacementVector.dy, 2), 0.5) / 3;
        
        CGFloat bX = movementVector.dx / v * l;
        CGFloat bY = movementVector.dy / v * l;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, 0);
        
        CGPathAddQuadCurveToPoint(path, NULL, bX, bY, displacementVector.dx, displacementVector.dy);
        
        SKAction *moveToPoint = [SKAction followPath:path speed:kOGPlayerPlayerSpeed];
        
        [self runAction:[SKAction sequence:@[
                                             moveToPoint,
                                             [SKAction performSelector:@selector(movePlayerToPointCompletion) onTarget:self]
                                             ]]
                withKey:kOGMovePlayerToPointActionKey];
    }
}

- (void)movePlayerToPointCompletion
{
    CGVector outerVector = self.movementVector;
    
    CGFloat l = pow(pow(outerVector.dx, 2) + pow(outerVector.dy, 2), 0.5);
    
    CGFloat x = outerVector.dx * kOGPlayerPlayerSpeed * self.physicsBody.mass / l;
    CGFloat y = outerVector.dy * kOGPlayerPlayerSpeed * self.physicsBody.mass / l;
    
    [self.physicsBody applyImpulse:CGVectorMake(x, y)];
}

- (void)moveByInertia
{
    CGVector movementVector = self.movementVector;
    
    CGPoint pointForImpulse = CGPointMake(self.position.x + movementVector.dx,
                                          self.position.y + movementVector.dy);
    
    [self removeActionForKey:kOGMovePlayerToPointActionKey];
    
    [self moveToPoint:pointForImpulse];
}

- (void)positionDidUpdate
{
    if (self.previousPositionsBuffer)
    {
        for (NSInteger i = self.previousPositionsBuffer.count - 1; i > 0; i--)
        {
            self.previousPositionsBuffer[i] = self.previousPositionsBuffer[i - 1];
        }
        self.previousPositionsBuffer[0] = [NSValue valueWithCGPoint:self.position];
    }
}

- (void)dealloc
{
    [_previousPositionsBuffer release];
    [super dealloc];
}


@end
