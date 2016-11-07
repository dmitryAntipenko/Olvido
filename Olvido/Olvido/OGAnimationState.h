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
    OGAnimationStateNone,
    OGAnimationStateIdle,
    OGAnimationStateWalkForward
};

NSString * const kOGAnimationStateDescription[] = {
    [OGAnimationStateNone] = @"none",
    [OGAnimationStateIdle] = @"idle",
    [OGAnimationStateWalkForward] = @"walkForward"
};

#endif /* OGAnimationState_h */
