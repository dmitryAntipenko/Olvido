//
//  OGIntelligenceComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGIntelligenceComponent : GKComponent

@property (nonatomic, strong) GKStateMachine *stateMachine;

- (instancetype)initWithStates:(NSArray<GKState *> *)states;
- (void)enterInitialState;

@end
