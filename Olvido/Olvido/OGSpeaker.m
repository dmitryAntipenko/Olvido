//
//  OGSpeaker.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSpeaker.h"
#import "OGSpeechCloud.h"

@implementation OGSpeaker

- (instancetype)initWithSpeechCloud:(OGSpeechCloud *)speechCloud
{
    self = [super init];
    
    if (self)
    {
        _speechCloud = [speechCloud retain];
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
    [_speechCloud release];
    
    [super dealloc];
}

@end
