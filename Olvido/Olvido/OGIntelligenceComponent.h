//
//  OGIntelligenceComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGIntelligenceComponent : GKComponent

- (instancetype)initWithStates:(NSArray<GKState *> *)states;
- (void)enterInitialState;

@end
