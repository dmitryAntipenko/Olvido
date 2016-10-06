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
    return [[[OGBonusNode alloc] initWithColor:color type:type] autorelease];
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
