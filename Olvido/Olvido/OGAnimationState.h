//
//  OGAnimationState.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

typedef NS_ENUM(NSUInteger, OGAnimationState)
{
    OGAnimationStateNone,
    OGAnimationStateIdle,
    OGAnimationStateWalkForward,
    OGAnimationStateRun,
    OGAnimationStateAttack,
    OGAnimationStateDead
};


static NSString *const OGAnimationStateDescription[] = {
    [OGAnimationStateNone] = @"none",
    [OGAnimationStateIdle] = @"idle",
    [OGAnimationStateWalkForward] = @"walkForward",
    [OGAnimationStateRun] = @"run",
    [OGAnimationStateAttack] = @"attack",
    [OGAnimationStateDead] = @"dead"
};
