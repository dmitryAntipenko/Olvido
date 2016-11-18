//
//  OGThumbStickNode.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGThumbStickNodeDelegate.h"
#import "OGGUINode.h"

@interface OGThumbStickNode : OGGUINode

@property (nonatomic, weak) id<OGThumbStickNodeDelegate> thumbStickNodeDelegate;

- (instancetype)initWithSize:(CGSize)size;

- (void)resetTouchPad;

@end
