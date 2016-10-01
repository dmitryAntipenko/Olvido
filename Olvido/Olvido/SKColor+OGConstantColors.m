//
//  SKColor+OGConstantColors.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKColor+OGConstantColors.h"

NSUInteger const kOGConstantColorsBackgroundLightGray = 0xf2f2f2;
NSUInteger const kOGConstantColorsBackgroundGray = 0xdddddd;
NSUInteger const kOGConstantColorsRed = 0xe74c3c;
NSUInteger const kOGConstantColorsBlue = 0x3498db;

@implementation SKColor (OGConstantColors)

+ (SKColor *)backgroundGrayColor
{
    return [SKColor colorWithHex:kOGConstantColorsBackgroundGray];
}

+ (SKColor *)backgroundLightGrayColor
{
    return [SKColor colorWithHex:kOGConstantColorsBackgroundLightGray];
}

+ (SKColor *)gameRed
{
    return [SKColor colorWithHex:kOGConstantColorsRed];
}

+ (SKColor *)gameBlue
{
    return [SKColor colorWithHex:kOGConstantColorsBlue];
}

+ (SKColor *)colorWithHex:(NSUInteger)hex
{
    return [SKColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                    green:((float)((hex & 0x00FF00) >>  8))/255.0
                     blue:((float)((hex & 0x0000FF) >>  0))/255.0
                    alpha:1.0];
}

@end
