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
#import "OGConstants.h"

NSString *const kOGBonusNodeTextureName = @"EnemyBall";

@implementation OGBonusNode

+ (instancetype)bonusNodeWithColor:(SKColor *)color type:(OGBonusType)type;
{
    OGBonusNode *bonus = [[OGBonusNode alloc] initWithColor:color type:type];
    
    if (bonus)
    {
        bonus.name = kOGBonusNodeName;
        
        SKTexture *bonusTexture = [SKTexture textureWithImageNamed:kOGBonusNodeTextureName];
        
        CGSize size = CGSizeMake(bonus.radius * 2.0,
                                 bonus.radius * 2.0);
        
        bonus.appearance = [SKSpriteNode spriteNodeWithTexture:bonusTexture size:size];
        
        if (bonus.appearance)
        {
            bonus.appearance.color = color;
            bonus.appearance.colorBlendFactor = 1.0;
            
            [bonus addChild:bonus.appearance];
            
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
    }
    
    return [bonus autorelease];
}

- (instancetype)initWithColor:(SKColor *)color type:(OGBonusType)type
{
    self = [self initWithColor:color];
    
    if (self)
    {
        _bonusType = type;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
