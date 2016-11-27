//
//  OGOrientationComponent.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/9/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGOrientationComponent.h"

@implementation OGOrientationComponent

+ (NSString *)orientationWithVectorX:(CGFloat)vectorX
{
    NSString *result = nil;
    
    if (vectorX > 0)
    {
        result = @"Right";
    }
    else
    {
        result = @"Left";
    }
    
    return result;
}

@end
