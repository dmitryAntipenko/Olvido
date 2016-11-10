//
//  OGAnimationState.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#ifndef OGAnimationState_h
#define OGAnimationState_h

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

#endif /* OGAnimationState_h */
