//
//  OGMovementControlComponent.h
//  Olvido
//
//  Created by Алексей Подолян on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGMovementControlComponent : GKComponent

@property (nonatomic, retain, readonly) SKNode *node;

- (instancetype)initWithNode:(SKNode *)node;

- (void)didTouchDownAtPoint:(CGPoint)point;

- (void)didTouchUpAtPoint:(CGPoint)point;

- (void)didTouchMoveToPoint:(CGPoint)point;

@end
