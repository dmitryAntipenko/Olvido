//
//  OGEnemy.h
//  Olvido
//
//  Created by Алексей Подолян on 9/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static inline CGPoint ogRanomPoint(CGFloat minX, CGFloat maxX, CGFloat minY, CGFloat maxY)
{
    CGFloat x = rand() / (CGFloat) RAND_MAX * (maxX - minX) + minX;
    CGFloat y = rand() / (CGFloat) RAND_MAX * (maxY - minY) + minY;
    
    return CGPointMake(x, y);
}

static inline CGFloat ogRand()
{
    return arc4random() / (CGFloat) RAND_MAX;
}

static inline CGVector ogRanomVector(CGFloat length)
{
    CGFloat angle = ogRand() * 2 * M_PI;
    
    return CGVectorMake(length * cosf(angle), length * sinf(angle));
}

extern NSString * __nonnull const kOGEnemyNodeName;
extern CGFloat const kOGEnemyVelocity;
extern uint32_t const kOGEnemyCategoryBitMask;

extern CGFloat const kOGInvulnerabilityRepeatCount;
extern CGFloat const kOGInvulnerabilityBlinkingTimeDuration;

@interface OGEnemy : SKSpriteNode

+ (nullable instancetype)enemy;

- (void)startWithPoint:(CGPoint)point;

@end
