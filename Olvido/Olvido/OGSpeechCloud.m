//
//  OGSpeechCloud.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSpeechCloud.h"

@implementation OGSpeechCloud

- (instancetype)initWithSpeechText:(NSString *)speechText
               animationActionType:(OGAnimationActionType)animationActionType
{
    self = [super init];
    
    if (self)
    {
        _speechText = [speechText copy];
        _animationActionType = animationActionType;
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
    [_speechText retain];
    
    [super dealloc];
}

- (void)showSpeechCloud
{
    
}

@end
