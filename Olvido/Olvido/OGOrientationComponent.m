//
//  OGOrientationComponent.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/9/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGOrientationComponent.h"

@implementation OGOrientationComponent

+ (OGDirection)directionWithVectorX:(CGFloat)vectorX
{
    OGDirection direction;
    
    if (vectorX > 0)
    {
        direction = OGDirectionRight;
    }
    else
    {
        direction = OGDirectionLeft;
    }
    
    return direction;
}

@end
