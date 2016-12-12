//
//  OGDoorEntityClosedState.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDoorEntityClosedState.h"
#import "OGDoorEntityOpenedState.h"
#import "OGDoorEntityLockedState.h"
#import "OGDoorEntityUnlockedState.h"

#import "OGDoorEntity.h"
#import "OGLockComponent.h"
#import "OGRenderComponent.h"
#import "OGSoundComponent.h"
#import "OGColliderType.h"

NSString *const OGDoorCloseSoundKey = @"door_close";

@interface OGDoorEntityClosedState ()

@property (nonatomic, weak) OGSoundComponent *soundComponent;

@end

@implementation OGDoorEntityClosedState

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
    
    self.lockComponent.closed = YES;
    ((SKSpriteNode *) self.renderComponent.node).colorBlendFactor = 0.0;
    self.renderComponent.node.physicsBody.categoryBitMask = (uint32_t) [OGColliderType door].categoryBitMask;
    
    if (previousState)
    {
        [self.soundComponent playSoundOnce:OGDoorCloseSoundKey];
    }
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [OGDoorEntityOpenedState class]
    || stateClass == [OGDoorEntityLockedState class]
    || stateClass == [OGDoorEntityLockedState class];
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];    
    
    if (!self.lockComponent.isLocked)
    {        
        if (self.lockComponent.isClosed && [self isTargetNearDoor])
        {
            if ([self.stateMachine canEnterState:[OGDoorEntityOpenedState class]])
            {
                [self.stateMachine enterState:[OGDoorEntityOpenedState class]];
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
