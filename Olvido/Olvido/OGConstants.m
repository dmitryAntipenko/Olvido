//
//  OGConstants.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGConstants.h"

NSString *const kOGPlayerNodeName = @"player";
NSString *const kOGEnemyNodeName = @"enemy";
NSString *const kOGObstacleNodeName = @"obstacle";
NSString *const kOGBonusNodeName = @"bonus";

NSString *const kOGEnemyTextureName = @"EnemyBall";
NSString *const kOGPlayerTextureName = @"PlayerBall";

NSUInteger const kOGLevelsCount = 3;

CGFloat const kOGPlayerNodeInvulnerabilityRepeatCount = 3.0;
CGFloat const kOGPlayerNodeInvulnerabilityBlinkingTimeDuration = 0.5;

CGFloat const kOGGameNodeDefaultSpeed = 1.0;

CGFloat const kOGConstantsOffset = 80.0;

@implementation OGConstants

+ (CGPoint)randomPointInRect:(CGRect)rect
{
    CGFloat maxX = rect.size.width - kOGConstantsOffset;
    CGFloat minX = kOGConstantsOffset;
    CGFloat maxY = rect.size.height - kOGConstantsOffset;
    CGFloat minY = kOGConstantsOffset;
    
    CGFloat x = rand() / (CGFloat) RAND_MAX * (maxX - minX) + minX;
    CGFloat y = rand() / (CGFloat) RAND_MAX * (maxY - minY) + minY;
    
    return CGPointMake(x, y);
}

+ (CGVector)randomVectorWithLength:(CGFloat)length
{
    CGFloat angle = (rand() / (CGFloat) RAND_MAX) * 2 * M_PI;
    
    return CGVectorMake(length * cosf(angle), length * sinf(angle));
}

@end
