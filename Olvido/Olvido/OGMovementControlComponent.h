//
//  OGMovementControlComponent.h
//  Olvido
//
//  Created by Алексей Подолян on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGMovementControlComponent : GKComponent

@property (nonatomic, retain) SKSpriteNode *spriteNode;
@property (nonatomic, assign) CGFloat speedFactor;

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode;

- (void)touchBeganAtPoint:(CGPoint)point;

- (void)touchEndedAtPoint:(CGPoint)point;

- (void)touchMovedToPoint:(CGPoint)point;

- (void)didChangeDirection;

- (void)stop;

@end
