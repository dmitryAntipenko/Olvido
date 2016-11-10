//
//  OGDoorEntityOpenedState.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDoorEntityClosedState.h"
#import "OGDoorEntityOpenedState.h"
#import "OGDoorEntity.h"

@interface OGDoorEntityOpenedState ()

@property (nonatomic, strong) OGDoorEntity *doorEntity;

@end

@implementation OGDoorEntityOpenedState

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
    [self.doorEntity open];
}

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;
    
    result = (result || stateClass == [OGDoorEntityClosedState class]);
    
    return result;
}

@end
