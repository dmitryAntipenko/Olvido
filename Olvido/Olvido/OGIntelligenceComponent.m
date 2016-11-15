//
//  OGIntelligenceComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGIntelligenceComponent.h"

@interface OGIntelligenceComponent ()

@property (nonatomic, strong) GKStateMachine *stateMachine;
@property (nonatomic, strong) Class initialStateClass;

@end

@implementation OGIntelligenceComponent

- (instancetype)initWithStates:(NSArray<GKState *> *)states
{
    if (states)
    {
        self = [super init];
        
        if (self)
        {
            _stateMachine = [GKStateMachine stateMachineWithStates:states];
            _initialStateClass = states.firstObject.class;
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];        
    
    [self.stateMachine updateWithDeltaTime:seconds];
}

- (void)enterInitialState
{
    if (self.initialStateClass)
    {
        [self.stateMachine enterState:self.initialStateClass];
    }
}

@end
