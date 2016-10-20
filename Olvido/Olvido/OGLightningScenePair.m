//
//  OGLightningScenePair.m
//  Olvido
//
//  Created by Алексей Подолян on 10/19/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLightningScenePair.h"
#import "OGSpriteNode.h"

CGFloat const kOGLightningScenePairBoltDisplacement = 0.1;
NSUInteger const kOGLightningScenePairBoltsCount = 1;

@interface OGLightningScenePair ()

@property (nonatomic, assign, readonly) SKEmitterNode *lightningEmitter;

@end

@implementation OGLightningScenePair

+ (instancetype)pairWithSpriteNodeA:(OGSpriteNode *)spriteNodeA spriteNodeB:(OGSpriteNode *)spriteNodeB
{
    OGLightningScenePair *pair = [[self alloc] initWithSpriteNodeA:spriteNodeA spriteNodeB:spriteNodeB];
    
    if (pair)
    {
        [pair update];
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
    self.texture = [SKTexture textureWithImageNamed:@"PlayerBall"];
    self.position = CGPointMake((self.spriteNodeA.position.x - self.spriteNodeB.position.x) / 2 + self.spriteNodeB.position.x,
                                (self.spriteNodeA.position.y - self.spriteNodeB.position.y) / 2 + self.spriteNodeB.position.y);
//    UIGraphicsBeginImageContext(CGSizeMake(fabs(self.spriteNodeA.position.x - self.spriteNodeB.position.x),
//                                           fabs(self.spriteNodeA.position.y - self.spriteNodeB.position.y)));
//    
//    for (NSUInteger i = 0; i < kOGLightningScenePairBoltsCount; i++)
//    {
//        [self drawBoltWithStartPoint:self.spriteNodeA.position endPoint:self.spriteNodeB.position displace:kOGLightningScenePairBoltDisplacement];
//    }
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
}

- (void)drawBoltWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint displace:(CGFloat)displace
{
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:startPoint];
//    
//    createBoltPath(startPoint.x, startPoint.y, endPoint.x, endPoint.y, displace, path);
//    
//    SKShapeNode *bolt = [SKShapeNode node];
//    bolt.path = path.CGPath;
//    bolt.strokeColor = [SKColor whiteColor];
//    bolt.lineWidth = 0.5f;
//    bolt.antialiased = NO;
//    [self addChild:bolt];
//    
//    SKShapeNode *shadowNode = [[SKShapeNode alloc] init];
//    shadowNode.path = path.CGPath;
//    shadowNode.strokeColor = [SKColor colorWithRed:0.702 green:0.745 blue:1 alpha:1.0];
//    shadowNode.lineWidth = 0.5f;
//    shadowNode.alpha = 0.4;
//    shadowNode.glowWidth = 5.f;
//    [self addChild:shadowNode];
}

- (BOOL)isEqual:(OGLightningScenePair *)object
{
    return ((self.spriteNodeA == object.spriteNodeA) && (self.spriteNodeB == object.spriteNodeB))
    || ((self.spriteNodeA == object.spriteNodeB) && (self.spriteNodeB == object.spriteNodeA));
}

@end



