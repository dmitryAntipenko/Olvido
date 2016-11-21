//
//  OGPlayerEntityControlledState.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/9/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
@class OGPlayerEntity;

@interface OGPlayerEntityControlledState : GKState

- (instancetype)initWithPlayerEntity:(OGPlayerEntity *)playerEntity;

@end
