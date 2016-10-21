//
//  OGGameState.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/19/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameState.h"
#import "OGMainMenuState.h"

@interface OGGameState ()

@property (nonatomic, retain) SKView *view;

@end

@implementation OGGameState

- (instancetype)initWithView:(SKView *)view
{
    self = [super init];
    
    if (self)
    {
        _view = [view retain];
    }
    else
    {
        [self release];
        self  = nil;
    }
    
    return self;
}

- (void)dealloc
{
    [_view release];
    
    [super dealloc];
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return YES;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{

}

@end
