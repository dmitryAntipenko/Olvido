//
//  OGPlayerEntityDieState.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/24/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
@class OGPlayerEntity;

@interface OGPlayerEntityDieState : GKState

- (instancetype)initWithPlayerEntity:(OGPlayerEntity *)playerEntity;

@end
