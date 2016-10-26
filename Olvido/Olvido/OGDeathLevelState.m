//
//  OGDeathLevelState.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDeathLevelState.h"
#import "OGInitLevelState.h"

@implementation OGDeathLevelState

- (BOOL)isValidNextState:(Class)stateClass
{
    BOOL result = NO;
    
    result = (result || stateClass == [OGInitLevelState class]);
    
    return result;
}

@end
