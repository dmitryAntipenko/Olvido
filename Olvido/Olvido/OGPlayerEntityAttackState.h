//
//  OGPlayerEntityAttackState.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
@class OGPlayerEntity;

@interface OGPlayerEntityAttackState : GKState

- (instancetype)initWithPlayerEntity:(OGPlayerEntity *)playerEntity;

@end
