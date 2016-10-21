//
//  OGGameState.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/19/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameState.h"
#import "OGMainMenuState.h"

@implementation OGGameState

- (BOOL)isValidNextState:(Class)stateClass
{
    return YES;
}

- (void)dealloc
{
    [_scenesController release];
    
    [super dealloc];
}
@end
