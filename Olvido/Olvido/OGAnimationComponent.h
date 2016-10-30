//
//  OGAnimationComponent.h
//  Olvido
//
//  Created by Алексей Подолян on 10/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class OGAnimationState;

@interface OGAnimationComponent : GKComponent

@property (nonatomic, assign) GKInspectable CGFloat timePerFrame;

- (void)playNextAnimationState:(OGAnimationState *)nextState;

- (void)pause;

- (void)resume;

@end
