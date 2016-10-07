//
//  SKColor+OGConstantColors.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 9/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

@interface SKColor (OGConstantColors)

+ (SKColor *)colorWithString:(NSString *)string;
+ (SKColor *)gameRed;
+ (SKColor *)backgroundLightGrayColor;
+ (SKColor *)backgroundGrayColor;
+ (SKColor *)gameBlue;
+ (SKColor *)gameBlack;

@end
