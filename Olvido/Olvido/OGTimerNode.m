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

@implementation OGTimerNode

- (instancetype)initWithPoint:(CGPoint)point
{
    self = [self init];
    
    if (self)
    {
        self.name = kOGTimerNodeName;
        self.fontColor = [SKColor backgroundGrayColor];
        self.fontSize = kOGTimerNodeFontDefaultSize;
        self.fontName = kOGTimerNodeFontName;
        self.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        self.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        self.position = point;
    }
    
    return self;
}

- (void)dealloc
{    
    [super dealloc];
}

@end
