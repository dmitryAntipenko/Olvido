//
//  OGTimerNode.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTimerNode.h"
#import "OGTimer.h"
#import "SKColor+OGConstantColors.h"

@interface OGTimerNode ()

@property (nonatomic, retain) OGTimer *timer;

@end

@implementation OGTimerNode

- (instancetype)initWithPoint:(CGPoint)point
{
    self = [self init];
    
    if (self)
    {
        _timer = [[OGTimer alloc] init];
        
        super.text = _timer.ticks.stringValue;
        super.fontColor = [SKColor backgroundGrayColor];
        super.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        super.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        super.position = point;
        
        [_timer startWithSelector:@selector(timerTick) sender:self];
    }
    
    return self;
}

- (void)timerTick
{
    self.timer.ticks = @(self.timer.ticks.integerValue + 1);
    self.text = self.timer.ticks.stringValue;
}

@end
