//
//  OGEntityDistance.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEntityDistance.h"

@implementation OGEntityDistance

- (instancetype)init
{
    return [self initWithSource:nil target:nil distance:0];
}

- (instancetype)initWithSource:(GKEntity *)source
                        target:(GKEntity *)target
                      distance:(CGFloat)distance
{
    self = [super init];
    
    if (self)
    {
        _source = source;
        _target = target;
        _distance = distance;
    }
    
    return self;
}

@end
