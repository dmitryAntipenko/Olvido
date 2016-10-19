//
//  OGMovementControlComponent.h
//  Olvido
//
//  Created by Алексей Подолян on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGMovementControlComponent : GKComponent

@property (nonatomic, retain, readonly) SKSpriteNode *spriteNode;
@property (nonatomic, assign) CGFloat speedFactor;

- (instancetype)initWithSpriteNode:(SKSpriteNode *)node;

- (void)touchBeganAtPoint:(CGPoint)point;

- (void)touchEndedAtPoint:(CGPoint)point;

- (void)touchMovedToPoint:(CGPoint)point;

- (void)stop;

@end
