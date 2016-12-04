//
//  OGDoorEntityOpenedState.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDoorEntityClosedState.h"
#import "OGDoorEntityOpenedState.h"
#import "OGDoorEntityLockedState.h"
#import "OGDoorEntityUnlockedState.h"
#import "OGCollisionBitMask.h"

#import "OGDoorEntity.h"
#import "OGLockComponent.h"
#import "OGRenderComponent.h"
#import "OGSoundComponent.h"

NSString *const OGDoorOpenSoundKey = @"door_open";

@interface OGDoorEntityOpenedState ()

@property (nonatomic, weak) OGSoundComponent *soundComponent;

@end

@implementation OGDoorEntityOpenedState

- (OGSoundComponent *)soundComponent
{
    if (!_soundComponent)
    {
        _soundComponent = (OGSoundComponent *) [self.doorEntity componentForClass:[OGSoundComponent class]];
    }
    
    return _soundComponent;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];
    
    self.lockComponent.closed = NO;
    ((SKSpriteNode *) self.renderComponent.node).color = [SKColor clearColor];
    self.renderComponent.node.physicsBody.categoryBitMask = 0;
    
    [self.soundComponent playSoundOnce:OGDoorOpenSoundKey];
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [OGDoorEntityClosedState class]
    || stateClass == [OGDoorEntityLockedState class]
    || stateClass == [OGDoorEntityLockedState class];
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    if (!self.lockComponent.isLocked)
    {        
        if (!self.lockComponent.isClosed && ![self isTargetNearDoor])
        {
            if ([self.stateMachine canEnterState:[OGDoorEntityClosedState class]])
            {
                [self.stateMachine enterState:[OGDoorEntityClosedState class]];
            }
        }
    }
    else
    {
        if ([self.stateMachine canEnterState:[OGDoorEntityLockedState class]])
        {
            [self.stateMachine enterState:[OGDoorEntityLockedState class]];
        }
    }
}

@end
