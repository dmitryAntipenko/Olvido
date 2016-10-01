//
//  OGTimer.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTimer.h"

@interface OGTimer ()

@property (nonatomic, retain) NSTimer *timer;

@end

@implementation OGTimer

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _ticks = @(0);
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
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (void)startWithSelector:(SEL)selector sender:(id)sender
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:sender selector:selector userInfo:nil repeats:YES];
}

- (void)tick
{
    self.ticks = @(self.ticks.integerValue + 1);
}

- (void)stop
{
    [self.timer invalidate];
    self.ticks = @(0);
}

@end
