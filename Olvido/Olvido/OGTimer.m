//
//  OGTimer.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTimer.h"

CGFloat const kOGTimerInterval = 1.0;

@interface OGTimer ()

@property (nonatomic, retain, readwrite) NSNumber *ticks;
@property (nonatomic, retain) NSTimer *timer;

@end

@implementation OGTimer

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _ticks = [[NSNumber alloc] initWithInt:0];
    }
    else
    {
        [self release];
        self = nil;
    }
    
    return self;
}

- (void)start
{
    self.ticks = @(0);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kOGTimerInterval target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (void)startWithSelector:(SEL)selector sender:(id)sender
{
    self.ticks = @(0);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kOGTimerInterval target:sender selector:selector userInfo:nil repeats:YES];
}

- (void)tick
{
    self.ticks = @(self.ticks.integerValue + 1);
}

- (void)stop
{
    [self.timer invalidate];
}

- (void)dealloc
{
    [_timer invalidate];
    [_timer release];
    [_ticks release];
    
    [super dealloc];
}

@end
