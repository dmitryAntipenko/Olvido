//
//  OGPlayer.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerNode.h"
#import "SKColor+OGConstantColors.h"
#import "OGCollisionBitMask.h"
#import "OGConstants.h"

CGFloat const kOGPlayerNodeBorderLineWidth = 4.0;
NSString *const kOGPlayerNodeSpriteImageName = @"PlayerBall";
CGFloat const kOGPlayerNodeSpeed = 300.0;
NSUInteger const kOGPlayerNodeDefaultPreviousPositionsBufferSize = 5;
NSString *const kOGPlayerNodeMoveToPointActionKey = @"movePlayerToPointActionKey";

@interface OGPlayerNode ()

@property (nonatomic, retain) NSMutableArray<NSValue *> *previousPositionsBuffer;
@property (nonatomic, assign, readonly) CGVector movementVector;
@property (nonatomic, assign, readonly) CGFloat movementVectorModule;
//@property (nonatomic, assign) CGFloat speedForPathFollowing;
@property (nonatomic, assign) CGPoint targetPoint;
@property (nonatomic, assign) CGFloat currentSpeed;
@property (nonatomic, assign) BOOL currentSpeedDidChanged;

@end

@implementation OGPlayerNode

+ (instancetype)playerNodeWithColor:(SKColor *)color
{
    OGPlayerNode *playerNode = [[OGPlayerNode alloc] initWithColor:color];
    
    if (playerNode)
    {
        playerNode.appearance = [SKSpriteNode spriteNodeWithImageNamed:kOGPlayerNodeSpriteImageName];
        
        if (playerNode.appearance)
        {
            playerNode.name = kOGPlayerNodeName;
            playerNode.appearance.size = CGSizeMake(playerNode.radius * 2.0,
                                                    playerNode.radius * 2.0);
            playerNode.appearance.color = [SKColor blackColor];
            playerNode.appearance.colorBlendFactor = 1.0;
            [playerNode addChild:playerNode.appearance];
            
            playerNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:kOGBasicGameNodeRadius];
            playerNode.physicsBody.dynamic = YES;
            playerNode.physicsBody.linearDamping = 0.0;
            playerNode.physicsBody.angularDamping = 0.0;
            
            playerNode.physicsBody.friction = 0.0;
            playerNode.physicsBody.restitution = 1.0;
            
            playerNode.physicsBody.categoryBitMask = kOGCollisionBitMaskPlayer;
            playerNode.physicsBody.collisionBitMask = kOGCollisionBitMaskObstacle;
            playerNode.physicsBody.contactTestBitMask = kOGCollisionBitMaskBonus | kOGCollisionBitMaskObstacle;
            
            playerNode.physicsBody.usesPreciseCollisionDetection = YES;
            
            [playerNode changeSpeedWithCoefficient:1.0];
            
            SKAction *invulnerability = [SKAction waitForDuration:kOGPlayerNodeInvulnerabilityRepeatCount * kOGPlayerNodeInvulnerabilityBlinkingTimeDuration * 2.0];
            
            [playerNode runAction:invulnerability completion:^
             {
                 playerNode.physicsBody.contactTestBitMask = playerNode.physicsBody.contactTestBitMask | kOGCollisionBitMaskEnemy;
             }];
        }
    }
    
    return  [playerNode autorelease];
}

- (void)setColor:(SKColor *)color
{
    self.appearance.color = color;
}

- (void)createPreviousPositionsBuffer
{
    NSMutableArray *result = [NSMutableArray array];
    
    for (int i = 0; i < kOGPlayerNodeDefaultPreviousPositionsBufferSize; i++)
    {
        NSValue *value = [NSValue valueWithCGPoint:self.position];
        [result addObject:value];
    }
    
    self.previousPositionsBuffer = result;
}

- (CGVector)movementVector
{
    if (!self.previousPositionsBuffer)
    {
        [self createPreviousPositionsBuffer];
    }
    
    CGVector result = CGVectorMake(0.0, 0.0);
    
    if (self.previousPositionsBuffer.count > 1)
    {
        NSInteger i = 0;
        while ((i < self.previousPositionsBuffer.count - 1)
               && [self.previousPositionsBuffer[0] isEqualToValue:self.previousPositionsBuffer[++i]]);
        
        CGPoint point1 = self.previousPositionsBuffer[0].CGPointValue;
        CGPoint point2 = self.previousPositionsBuffer[i].CGPointValue;
        
        result.dx = point1.x - point2.x;
        result.dy = point1.y - point2.y;
    }
    
    return result;
}

- (void)moveToPoint:(CGPoint)point
{
    self.targetPoint = point;
    
    self.physicsBody.velocity = CGVectorMake(0, 0);
    [self removeActionForKey:kOGPlayerNodeMoveToPointActionKey];
    
    CGVector displacementVector = CGVectorMake(point.x - self.position.x,
                                               point.y - self.position.y);
    
    CGVector movementVector = self.movementVector;
    
    CGFloat displacementVectorModule = pow(pow(displacementVector.dx, 2) + pow(displacementVector.dy, 2), 0.5);
    
    if (movementVector.dx == 0.0 && movementVector.dy == 0.0)
    {
        CGFloat x = displacementVector.dx * self.currentSpeed / displacementVectorModule * self.physicsBody.mass;
        CGFloat y = displacementVector.dy * self.currentSpeed / displacementVectorModule * self.physicsBody.mass;
        
        [self.physicsBody applyImpulse:CGVectorMake(x, y)];
    }
    else
    {
        CGFloat movementVectorModule = self.movementVectorModule;
        
        CGFloat bX = movementVector.dx * displacementVectorModule / 3 / movementVectorModule;
        CGFloat bY = movementVector.dy * displacementVectorModule / 3 / movementVectorModule;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, 0);
        
        CGPathAddQuadCurveToPoint(path, NULL, bX, bY, displacementVector.dx, displacementVector.dy);
        
        SKAction *moveToPoint = [SKAction followPath:path speed:self.currentSpeed];
        
        [self runAction:[SKAction sequence:@[
                                             moveToPoint,
                                             [SKAction performSelector:@selector(moveByInertia) onTarget:self]
                                             ]]
                withKey:kOGPlayerNodeMoveToPointActionKey];
        
        CGPathRelease(path);
    }
}

- (void)moveByInertia
{
    CGVector movementVector = self.movementVector;
    
    CGFloat movementVectorModule = self.movementVectorModule;
    
    CGVector impulse = CGVectorMake(movementVector.dx * self.currentSpeed * self.physicsBody.mass / movementVectorModule,
                                    movementVector.dy * self.currentSpeed * self.physicsBody.mass / movementVectorModule);
    
    if ([self actionForKey:kOGPlayerNodeMoveToPointActionKey])
    {
        [self removeActionForKey:kOGPlayerNodeMoveToPointActionKey];
        [self.physicsBody applyImpulse:impulse];
    }
    else if (self.currentSpeedDidChanged)
    {
        self.physicsBody.velocity = CGVectorMake(0.0, 0.0);
        [self.physicsBody applyImpulse:impulse];
    }
    
    self.currentSpeedDidChanged = NO;
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

- (CGFloat)movementVectorModule
{
    CGVector movementVector = self.movementVector;
    return pow(pow(movementVector.dx, 2) + pow(movementVector.dy, 2), 0.5);
}

- (void)changeSpeedWithCoefficient:(CGFloat)speedCoefficient;
{
    self.currentSpeed = kOGPlayerNodeSpeed * speedCoefficient;
    self.currentSpeedDidChanged = YES;
    
    if ([self actionForKey:kOGPlayerNodeMoveToPointActionKey])
    {
        [self moveToPoint:self.targetPoint];
    }
    else
    {
        [self moveByInertia];
    }
}

- (void)dealloc
{
    [_previousPositionsBuffer release];
    
    [super dealloc];
}

@end
