//
//  OGLightningScenePair.m
//  Olvido
//
//  Created by Алексей Подолян on 10/19/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLightningScenePair.h"
#import "OGSpriteNode.h"

CGFloat const kOGLightningScenePairBoltDisplace = 50.0;
NSUInteger const kOGLightningScenePairBoltsCount = 1;
CGFloat const kOGLightningScenePairBoltDetailFactor = 1.0;
CGFloat const kOGLightningScenePairUpdateTimeDuration = 0.05;
CGFloat const kOGLightningScenePairBoltWidth = 2.0;

@interface OGLightningScenePair ()

@property (nonatomic, assign, readonly) SKEmitterNode *lightningEmitter;

@end

@implementation OGLightningScenePair

+ (instancetype)pairWithSpriteNodeA:(OGSpriteNode *)spriteNodeA spriteNodeB:(OGSpriteNode *)spriteNodeB
{
    OGLightningScenePair *pair = [[self alloc] initWithSpriteNodeA:spriteNodeA spriteNodeB:spriteNodeB];
    
    if (pair)
    {
        [pair runAction:[SKAction repeatActionForever:[SKAction sequence:@[
                                                                           [SKAction waitForDuration:kOGLightningScenePairUpdateTimeDuration],
                                                                           [SKAction performSelector:@selector(update) onTarget:pair]
                                                                           ]]]];
    }
    
    return [pair autorelease];
}

- (instancetype)initWithSpriteNodeA:(OGSpriteNode *)spriteNodeA spriteNodeB:(OGSpriteNode *)spriteNodeB
{
    self = [self init];
    
    if (self)
    {
        _spriteNodeA = spriteNodeA;
        _spriteNodeB = spriteNodeB;
    }
    
    return self;
}

- (void)update
{
    CGFloat minX = fmin(self.spriteNodeA.position.x, self.spriteNodeB.position.x);
    CGFloat minY = fmin(self.spriteNodeA.position.y, self.spriteNodeB.position.y);
    
    CGPoint startPoint = CGPointMake(self.spriteNodeA.position.x - minX, self.spriteNodeA.position.y - minY);
    CGPoint endPoint = CGPointMake(self.spriteNodeB.position.x - minX, self.spriteNodeB.position.y - minY);
    
    UIGraphicsBeginImageContext(CGSizeMake(fabs(self.spriteNodeA.position.x - self.spriteNodeB.position.x),
                                           fabs(self.spriteNodeA.position.y - self.spriteNodeB.position.y)));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.size.width, 0);
    CGContextScaleCTM(context, -1.0f, 1.0f);
    
    for (NSUInteger i = 0; i < kOGLightningScenePairBoltsCount; i++)
    {
        [self drawBoltWithStartPoint:startPoint endPoint:endPoint];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.texture = [SKTexture textureWithImage:image];
    
    self.size = image.size;
    
    CGFloat midX = (self.spriteNodeA.position.x + self.spriteNodeB.position.x) / 2;
    CGFloat midY = (self.spriteNodeA.position.y + self.spriteNodeB.position.y) / 2;
    
    CGPoint midPoint = CGPointMake(midX, midY);
    
    self.position = midPoint;
}

- (void)drawBoltWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [self createBoltPathWithPointA:startPoint pointB:endPoint displace:kOGLightningScenePairBoltDisplace path:path];
    
    path.lineWidth = 1.0;
    [[SKColor whiteColor] setStroke];
    [path stroke];
}

- (void)createBoltPathWithPointA:(CGPoint)pointA pointB:(CGPoint)pointB displace:(CGFloat)displace path:(UIBezierPath*)path
{
    CGFloat distanse = hypot(pointA.x - pointB.x, pointA.y - pointB.y);
    
    if (distanse * displace < kOGLightningScenePairBoltDetailFactor)
    {
        [path addLineToPoint:pointB];
    }
    else
    {
        CGFloat midX = (pointA.x + pointB.x) * 0.5 + ((arc4random_uniform(100) * 0.01 - 0.5) * displace);
        CGFloat midY = (pointA.y + pointB.y) * 0.5 + ((arc4random_uniform(100) * 0.01 - 0.5) * displace);
        
        CGPoint midPoint = CGPointMake(midX, midY);
        
        [self createBoltPathWithPointA:pointA pointB:midPoint displace:displace * 0.5 path:path];
        [self createBoltPathWithPointA:midPoint pointB:pointB displace:displace * 0.5 path:path];
    }
}

- (BOOL)isEqual:(OGLightningScenePair *)object
{
    return ((self.spriteNodeA == object.spriteNodeA) && (self.spriteNodeB == object.spriteNodeB))
    || ((self.spriteNodeA == object.spriteNodeB) && (self.spriteNodeB == object.spriteNodeA));
}

@end



