//
//  OGShootingButtonNode.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/12/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
//#import "OGActionButtonNodeDelegate.h"
#import "OGGUINode.h"


@protocol OGActionButtonNodeDelegate <NSObject>

- (void)actionButtonNode:(SKSpriteNode *)node isPressed:(BOOL)pressed;

@end

@interface OGActionButtonNode : OGGUINode

@property (nonatomic, weak) id<OGActionButtonNodeDelegate> actionButtonNodeDelegate;

- (instancetype)initWithSize:(CGSize)size;

- (void)resetButton;

@end
