//
//  OGTimer.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTimer.h"

NSNumber *const kOGTimerTicksStartValue = 0;
NSInteger const kOGTimerTicksIncrement = 1;

@interface OGTimer ()

@property (nonatomic, retain) NSTimer *timer;

@end

@implementation OGTimer

- (instancetype)init
{
    self = [super init];
    
    if (!self)
    {
        [self release];
        self = nil;
    }
    
    return self;
}

- (void)startWithInterval:(CGFloat)interval selector:(SEL)selector sender:(id)sender
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:sender selector:selector userInfo:nil repeats:YES];
}

- (void)stop
{
    [self.timer invalidate];
}


- (void)pause
{
    
}

- (void)resume
{
    
}

-(void)pauseTimer:(NSTimer *)timer {
    
    pauseStart = [[NSDate date] retain];
    
    previousFireDate = [[timer fireDate] retain];
    
    [timer setFireDate:[NSDate distantFuture]];
}

-(void)resumeTimer:(NSTimer *)timer {
    
    float pauseTime = -1*[pauseStart timeIntervalSinceNow];
    
    [timer setFireDate:[previousFireDate initWithTimeInterval:pauseTime sinceDate:previousFireDate]];
    
    [pauseStart release];
    
    [previousFireDate release];
}

- (void)dealloc
{
    [_timer invalidate];
    [_timer release];
    
    [super dealloc];
}

@end
