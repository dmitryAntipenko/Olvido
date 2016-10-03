//
//  OGTimerNode.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGTimer.h"

extern NSString *const kOGTimerNodeName;
extern CGFloat const kOGTimerNodeFontDefaultSize;

@interface OGTimerNode : SKLabelNode

@property (nonatomic, readonly, retain) OGTimer *timer;

- (instancetype)initWithPoint:(CGPoint)point;

@end
