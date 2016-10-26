//
//  OGMovementControlComponent.h
//  Olvido
//
//  Created by Алексей Подолян on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGVisualComponent.h"

@interface OGMovementControlComponent : GKComponent

@property (nonatomic, assign) OGVisualComponent *visualComponent;
@property (nonatomic, assign) GKInspectable CGFloat speedFactor;
@property (nonatomic, assign) GKInspectable CGFloat defaultSpeed;

- (void)touchBeganAtPoint:(CGPoint)point;

- (void)touchEndedAtPoint:(CGPoint)point;

- (void)touchMovedToPoint:(CGPoint)point;

- (void)didChangeDirection;

- (void)pause;

- (void)resume;

@end
