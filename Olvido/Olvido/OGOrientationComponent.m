//
//  OGOrientationComponent.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/9/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGOrientationComponent.h"

@implementation OGOrientationComponent

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _zRotation = 0.0;
    }
    
    return self;
}

- (OGDirection)directionWithZRotation:(CGFloat)zRotation
{
    OGDirection result;
    
    CGFloat degreeZRotation = GLKMathRadiansToDegrees(zRotation);
    
    if (degreeZRotation >= 90.0 && degreeZRotation <= 270.0)
    {
        result = OGDirectionLeft;
    }
    else
    {
        result = OGDirectionRight;
    }
    
    return result;
}

- (OGDirection)direction
{
    return [self directionWithZRotation:self.zRotation];
}

@end
