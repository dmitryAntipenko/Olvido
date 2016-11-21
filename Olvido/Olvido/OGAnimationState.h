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
    kOGAnimationStateAttack
};


static NSString *const kOGAnimationStateDescription[] = {
    [kOGAnimationStateNone] = @"none",
    [kOGAnimationStateIdle] = @"idle",
    [kOGAnimationStateWalkForward] = @"walkForward",
    [kOGAnimationStateAttack] = @"atack"
};
