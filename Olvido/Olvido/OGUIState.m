//
//  OGUIState.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGUIState.h"

@interface OGUIState ()



@end

@implementation OGUIState

- (instancetype)initWithView:(SKView *)view
{
    self = [super init];
    
    if (self)
    {
        _view = [view retain];
    }
    else
    {
        [self release];
        self  = nil;
    }
    
    return self;
}

- (void)dealloc
{
    [_view release];
    
    [super dealloc];
}

@end
