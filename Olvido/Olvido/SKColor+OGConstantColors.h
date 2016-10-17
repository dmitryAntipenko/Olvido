//
//  SKColor+OGConstantColors.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

@interface SKColor (OGConstantColors)

+ (SKColor *)colorWithString:(NSString *)string;
+ (SKColor *)inverseColor:(SKColor *)color;

+ (SKColor *)gameRed;
+ (SKColor *)gameDarkRed;

+ (SKColor *)gameGreen;
+ (SKColor *)gameDarkGreen;

+ (SKColor *)backgroundLightGrayColor;
+ (SKColor *)backgroundGrayColor;

+ (SKColor *)gameBlue;
+ (SKColor *)gameDarkBlue;

+ (SKColor *)gameBlack;
+ (SKColor *)gameLightBlack;

+ (SKColor *)gameWhite;

@end
