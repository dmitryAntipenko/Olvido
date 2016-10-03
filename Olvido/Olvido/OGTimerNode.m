//
//  OGTimerNode.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTimerNode.h"
#import "SKColor+OGConstantColors.h"

NSString *const kOGTimerNodeName = @"timerNode";
NSString *const kOGTimerNodeKeyPathTicks = @"ticks";
NSString *const kOGTimerNodeFontName = @"Helvetica-Thin";
CGFloat const kOGTimerNodeFontDefaultSize = 64.0;

@interface OGTimerNode ()

@property (nonatomic, retain) OGTimer *timer;

@end

@implementation OGTimerNode

static NSInteger kTimerContext;

- (instancetype)initWithPoint:(CGPoint)point
{
    self = [self init];
    
    if (self)
    {
        _timer = [[OGTimer alloc] init];
        
        self.name = kOGTimerNodeName;
        self.text = _timer.ticks.stringValue;
        self.fontColor = [SKColor backgroundGrayColor];
        self.fontSize = kOGTimerNodeFontDefaultSize;
        self.fontName = kOGTimerNodeFontName;
        self.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        self.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        self.position = point;
        
        [_timer start];
        
        [_timer addObserver:self
                 forKeyPath:kOGTimerNodeKeyPathTicks
                    options:NSKeyValueObservingOptionPrior
                    context:&kTimerContext];
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (context == &kTimerContext)
    {
        self.text = self.timer.ticks.stringValue;
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
    [_timer removeObserver:self forKeyPath:kOGTimerNodeKeyPathTicks];
    
    [_timer release];
    
    [super dealloc];
}

@end
