//
//  OGBonusNode.m
//  Olvido
//
//  Created by Алексей Подолян on 10/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGBonusNode.h"

@implementation OGBonusNode

+ (instancetype)bonusNodeWithColor:(SKColor *)color Type:(OGBonusType)type;
{
    OGBonusNode *bonus = [[OGBonusNode alloc] initWithColor:color type:type];
    
    if (bonus)
    {
        CGRect physicsBodyPathRect = CGRectMake(-bonus.radius,
                                                -bonus.radius,
                                                bonus.radius * 2,
                                                bonus.radius * 2);
        CGPathRef physicsBodyPath = CGPathCreateWithEllipseInRect(physicsBodyPathRect, NULL);
        
        bonus.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:physicsBodyPath];
        bonus.physicsBody.categoryBitMask = 0x0 << 5;//make constant!!
        bonus.physicsBody.contactTestBitMask = 0x0;
        bonus.physicsBody.collisionBitMask = 0x0;
    }
    
    return [bonus autorelease];
}

- (instancetype)initWithColor:(SKColor *)color type:(OGBonusType)type
{
    self = [self initWithColor:color];
    
    if (self)
    {
        _type = type;
    }
    
    return self;
}


@end
