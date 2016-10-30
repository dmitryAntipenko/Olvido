//
//  OGAnimationComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 10/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGAnimationComponent.h"
#import "OGAnimationState.h"

@interface OGAnimationComponent ()

@property (nonatomic, retain) OGAnimationState *currentState;

@end

@implementation OGAnimationComponent

- (void)enterNextState:(OGAnimationState *)nextState
{
    if (nextState && [self.currentState isValidNextState:nextState])
    {
        
    }
}

@end
