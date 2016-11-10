//
//  OGDoorEntityClosedState.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDoorEntityClosedState.h"
#import "OGDoorEntityOpenedState.h"
#import "OGDoorEntity.h"

@interface OGDoorEntityClosedState ()

@property (nonatomic, strong) OGDoorEntity *doorEntity;

@end

@implementation OGDoorEntityClosedState

- (instancetype)initWithDoorEntity:(OGDoorEntity *)entity
{
    self = [super init];
    
    if (self)
    {
        _doorEntity = entity;
    }
    
    return self;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [self.doorEntity close];
}

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;
    
    result = (result || stateClass == [OGDoorEntityOpenedState class]);
    
    return result;
}

@end
