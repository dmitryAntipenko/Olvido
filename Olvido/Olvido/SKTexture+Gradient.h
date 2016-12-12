//
//  SKTexture+Gradient.h
//  Olvido
//
//  Created by Александр Песоцкий on 12/12/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKTexture (Gradient)

+ (SKTexture*)textureWithVerticalGradientOfSize:(CGSize)size
                                  topRightColor:(CIColor*)topColor
                                bottomLeftColor:(CIColor*)bottomColor;

@end
