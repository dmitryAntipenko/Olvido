//
//  SKColor+OGConstantColors.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKColor+OGConstantColors.h"

NSUInteger const OGConstantColorsBackgroundLightGray = 0xf2f2f2;
NSUInteger const OGConstantColorsBackgroundGray = 0xdddddd;

NSUInteger const OGConstantColorsRed = 0xe74c3c;
NSUInteger const OGConstantColorsDarkRed = 0xc0392b;

NSUInteger const OGConstantColorsBlue = 0x3498db;
NSUInteger const OGConstantColorsDarkBlue = 0x2980b9;

NSUInteger const OGConstantColorsBlack = 0x11181f;
NSUInteger const OGConstantColorsLightBlack = 0x2c3e50;

NSUInteger const OGConstantColorsGreen = 0x1abc9c;
NSUInteger const OGConstantColorsDarkGreen = 0x16a085;

NSUInteger const OGConstantColorsWhite = 0xecf0f1;

@implementation SKColor (OGConstantColors)

+ (SKColor *)backgroundGrayColor
{
    return [SKColor colorWithHex:OGConstantColorsBackgroundGray];
}

+ (SKColor *)backgroundLightGrayColor
{
    return [SKColor colorWithHex:OGConstantColorsBackgroundLightGray];
}

+ (SKColor *)gameRed
{
    return [SKColor colorWithHex:OGConstantColorsRed];
}

+ (SKColor *)gameDarkRed
{
    return [SKColor colorWithHex:OGConstantColorsDarkRed];
}

+ (SKColor *)gameGreen
{
    return [SKColor colorWithHex:OGConstantColorsGreen];
}

+ (SKColor *)gameDarkGreen
{
    return [SKColor colorWithHex:OGConstantColorsDarkGreen];
}

+ (SKColor *)gameBlue
{
    return [SKColor colorWithHex:OGConstantColorsBlue];
}

+ (SKColor *)gameDarkBlue
{
    return [SKColor colorWithHex:OGConstantColorsDarkBlue];
}

+ (SKColor *)gameBlack
{
    return [SKColor colorWithHex:OGConstantColorsBlack];
}

+ (SKColor *)gameLightBlack
{
    return [SKColor colorWithHex:OGConstantColorsLightBlack];
}

+ (SKColor *)gameWhite
{
    return [SKColor colorWithHex:OGConstantColorsWhite];
}

+ (SKColor *)colorWithHex:(NSUInteger)hex
{
    return [SKColor colorWithRed:((float) ((hex & 0xFF0000) >> 16)) / 255.0
                           green:((float) ((hex & 0x00FF00) >>  8)) / 255.0
                            blue:((float) ((hex & 0x0000FF) >>  0)) / 255.0
                           alpha:1.0];
}

+ (SKColor *)colorWithString:(NSString *)string
{
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:string];
    
    [scanner scanHexInt:&result];
    
    return [self colorWithHex:result];
}

+ (SKColor *)inverseColor:(SKColor *)color
{
    CGFloat r,g,b,a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:1.-r green:1.-g blue:1.-b alpha:a];
}

@end
