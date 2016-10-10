//
//  OGBonusNode.h
//  Olvido
//
//  Created by Алексей Подолян on 10/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OGBasicGameNode.h"

typedef NS_ENUM(NSUInteger, OGBonusType)
{
    kOGBonusTypeSlowMo = 0,
    kOGBonusTypeSpeedUp = 1,
    kOGBonusTypeSlowMoEnemies = 2,
    kOGBonusTypeEnemyEnlarge = 3
};

@interface OGBonusNode : OGBasicGameNode

@property (nonatomic, assign, readonly) OGBonusType bonusType;

+ (instancetype)bonusNodeWithColor:(SKColor *)color type:(OGBonusType)type;
    
@end
