//
//  OGThumbStickNode.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol OGThumbStickNodeDelegate

- (void)thumbStickNode:(SKSpriteNode *)node didUpdateXValue:(CGFloat)xValue yValue:(CGFloat)yValue;
- (void)thumbStickNode:(SKSpriteNode *)node isPressed:(BOOL)pressed;

@end

@interface OGThumbStickNode : SKSpriteNode

@property (nonatomic, weak) id<OGThumbStickNodeDelegate> thumbStickNodeDelegate;

- (instancetype)initWithSize:(CGSize)size;

- (void)resetTouchPad;

@end
