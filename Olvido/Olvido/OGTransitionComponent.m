//
//  OGTransitionComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTransitionComponent.h"

@implementation OGTransitionComponent

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _closed = YES;
    }
    else
    {
        [self release];
        self = nil;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
