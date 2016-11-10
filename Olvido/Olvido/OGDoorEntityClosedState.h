//
//  OGDoorEntityClosedState.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class OGDoorEntity;

@interface OGDoorEntityClosedState : GKState

- (instancetype)initWithDoorEntity:(OGDoorEntity *)entity;

@end
