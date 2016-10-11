//
//  OGEnemyNode.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGBasicGameNode.h"

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

@interface OGEnemyNode : OGBasicGameNode

+ (instancetype)enemyNode;

- (void)startWithPoint:(CGPoint)point;

- (void)changeSpeedWithFactor:(CGFloat)speedFactor;

@end
