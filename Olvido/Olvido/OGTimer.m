//
//  OGTimer.m
//  Olvido
//
//  Created by Алексей Подолян on 12/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTimer.h"

NSNumber *const kOGTimerTicksStartValue = 0;
NSInteger const kOGTimerTicksIncrement = 1;

@interface OGTimer ()

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSDate *pauseDate;
@property (nonatomic, retain) NSDate *previouseFireDate;
@property (nonatomic, assign) BOOL paused;

@end

@implementation OGTimer

- (void)startWithInterval:(NSTimeInterval)interval selector:(SEL)selector sender:(id)sender
{
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:sender selector:selector userInfo:nil repeats:YES];
}

- (void)stop
{
    [self.timer invalidate];
}

- (void)pause
{
    if (!self.paused)
    {
        self.pauseDate = [NSDate date];
        self.previouseFireDate = self.timer.fireDate;
        
        self.timer.fireDate = [NSDate distantFuture];
        
        self.paused = YES;
    }
}

- (void)resume
{
    if (self.paused)
    {
        NSTimeInterval dTime = (-1) * self.pauseDate.timeIntervalSinceNow;
        self.timer.fireDate = [NSDate dateWithTimeInterval:dTime sinceDate:self.previouseFireDate];
        
        self.paused = NO;
    }
}

- (void)dealloc
{
    [_timer invalidate];
}

@end
