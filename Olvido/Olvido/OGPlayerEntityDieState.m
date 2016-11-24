//
//  OGPlayerEntityDieState.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/24/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerEntityDieState.h"
#import "OGPlayerEntity.h"

@interface OGPlayerEntityDieState ()

@property (nonatomic, weak) OGPlayerEntity *playerEntity;

@end

@implementation OGPlayerEntityDieState

- (instancetype)initWithPlayerEntity:(OGPlayerEntity *)playerEntity
{
    self = [self init];
    
    if (self)
    {
        _playerEntity = playerEntity;
    }
    
    return self;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    [self.playerEntity entityDidDie];
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return NO;
}

@end
