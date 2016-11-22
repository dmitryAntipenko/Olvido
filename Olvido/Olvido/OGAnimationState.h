//
//  OGAnimationState.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

typedef NS_ENUM(NSUInteger, OGAnimationState)
{
    kOGAnimationStateNone,
    kOGAnimationStateIdle,
    kOGAnimationStateWalkForward,
    kOGAnimationStateRun,
    kOGAnimationStateAttack,
    kOGAnimationStateDead
};


static NSString *const kOGAnimationStateDescription[] = {
    [kOGAnimationStateNone] = @"none",
    [kOGAnimationStateIdle] = @"idle",
    [kOGAnimationStateWalkForward] = @"walkForward",
    [kOGAnimationStateRun] = @"run",
    [kOGAnimationStateAttack] = @"attack",
    [kOGAnimationStateDead] = @"dead"
};
