//
//  OGBonusNode.m
//  Olvido
//
//  Created by Алексей Подолян on 10/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGBonusNode.h"
#import "OGCollisionBitMask.h"
#import "OGBasicGameNode.h"

@implementation OGBonusNode

+ (instancetype)bonusNodeWithColor:(SKColor *)color Type:(OGBonusType)type;
{
    OGBonusNode *bonus = [[OGBonusNode alloc] initWithColor:color type:type];
    
    if (bonus)
    {
        CGRect physicsBodyPathRect = CGRectMake(-bonus.radius,
                                                -bonus.radius,
                                                bonus.radius * 2.0,
                                                bonus.radius * 2.0);
        
        CGPathRef physicsBodyPath = CGPathCreateWithEllipseInRect(physicsBodyPathRect, NULL);
        
        bonus.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:physicsBodyPath];
        bonus.physicsBody.categoryBitMask = kOGCollisionBitMaskBonus;
        bonus.physicsBody.contactTestBitMask = kOGCollisionBitMaskDefault;
        bonus.physicsBody.collisionBitMask = kOGCollisionBitMaskDefault;
        
        CGPathRelease(physicsBodyPath);
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

- (void)dealloc
{
    [super dealloc];
}

@end
