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
    type
};

@interface OGBonusNode : OGBasicGameNode

@property (nonatomic, assign, readonly) OGBonusType type;

+ (instancetype)bonusNodeWithColor:(SKColor *)color Type:(OGBonusType)type;
    
@end
