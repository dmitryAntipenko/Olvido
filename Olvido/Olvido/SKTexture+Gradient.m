//
//  SKTexture+Gradient.m
//  Olvido
//
//  Created by Александр Песоцкий on 12/12/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "SKTexture+Gradient.h"

NSString *const SKTextureGradientFilterName = @"CILinearGradient";

NSString *const SKTextureStartInputPoint = @"inputPoint0";
NSString *const SKTextureEndInputPoint = @"inputPoint1";

NSString *const SKTextureTopRightInputColor = @"inputColor0";
NSString *const SKTextureBottomRightInputColor = @"inputColor1";

@implementation SKTexture (Gradient)

+ (SKTexture*)textureWithVerticalGradientOfSize:(CGSize)size
                                  topRightColor:(CIColor*)topRightColor
                                bottomLeftColor:(CIColor*)bottomLeftColor
{
    CIContext *coreImageContext = [CIContext contextWithOptions:nil];
    CIFilter *gradientFilter = [CIFilter filterWithName:SKTextureGradientFilterName];
    
    [gradientFilter setDefaults];
    
    CIVector *startVector = [CIVector vectorWithX:size.width Y:size.height];
    CIVector *endVector = [CIVector vectorWithX:0 Y:0];
    
    
    [gradientFilter setValue:startVector forKey:SKTextureStartInputPoint];
    [gradientFilter setValue:endVector forKey:SKTextureEndInputPoint];
    [gradientFilter setValue:topRightColor forKey:SKTextureTopRightInputColor];
    [gradientFilter setValue:bottomLeftColor forKey:SKTextureBottomRightInputColor];
  
    CGImageRef cgimg = [coreImageContext createCGImage:[gradientFilter outputImage]
                                              fromRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *image = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    return [SKTexture textureWithImage:image];
}

@end
