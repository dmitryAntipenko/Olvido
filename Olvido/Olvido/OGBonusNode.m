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
CGFloat const kOGBonusNodeAppearanceColorBlendFactor = 1.0;

@implementation OGBonusNode

+ (instancetype)bonusNodeWithColor:(SKColor *)color type:(OGBonusType)type;
{
    OGBonusNode *bonus = [[OGBonusNode alloc] initWithColor:color type:type];
    
    if (bonus)
    {
        bonus.name = kOGBonusNodeName;
        
        SKTexture *bonusTexture = [SKTexture textureWithImageNamed:kOGBonusNodeTextureName];
        
        CGSize size = CGSizeMake(bonus.diameter,
                                 bonus.diameter);
        
        bonus.appearance = [SKSpriteNode spriteNodeWithTexture:bonusTexture size:size];
        
        if (bonus.appearance)
        {
            bonus.appearance.color = color;
            bonus.appearance.colorBlendFactor = kOGBonusNodeAppearanceColorBlendFactor;
            
            [bonus addChild:bonus.appearance];
            
            CGRect physicsBodyPathRect = CGRectMake(-bonus.radius,
                                                    -bonus.radius,
                                                    bonus.diameter,
                                                    bonus.diameter);
            
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
