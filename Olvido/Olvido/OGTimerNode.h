//
//  OGTimerNode.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

extern NSString *const kOGTimerNodeName;
extern CGFloat const kOGTimerNodeFontDefaultSize;

@interface OGTimerNode : SKLabelNode

- (instancetype)initWithPoint:(CGPoint)point;

@end
