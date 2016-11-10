//
//  OGDoorEntity.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDoorEntity.h"
#import "OGColliderType.h"
#import "OGRenderComponent.h"
#import "OGIntelligenceComponent.h"
#import "OGAnimationComponent.h"
#import "OGPhysicsComponent.h"
#import "OGLockComponent.h"

#import "OGPlayerEntity.h"

#import "OGDoorEntityClosedState.h"
#import "OGDoorEntityOpenedState.h"
#import "OGDoorEntityLockedState.h"
#import "OGDoorEntityUnlockedState.h"

@implementation OGDoorEntity

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode;
{
    self = [super init];
    
    if (self)
    {
        [OGDoorEntity loadMiscellaneousAssets];
        
        _render = [[OGRenderComponent alloc] init];
        _render.node = spriteNode;
        [self addComponent:_render];
        
        _physics = [[OGPhysicsComponent alloc] initWithPhysicsBody:spriteNode.physicsBody
                                                      colliderType:[OGColliderType door]];
        [self addComponent:_physics];
        
        _render.node.physicsBody = _physics.physicsBody;
        
        _intelligence = [[OGIntelligenceComponent alloc] initWithStates:@[
            [[OGDoorEntityClosedState alloc] initWithDoorEntity:self],
            [[OGDoorEntityOpenedState alloc] initWithDoorEntity:self],
            [[OGDoorEntityLockedState alloc] initWithDoorEntity:self],
            [[OGDoorEntityUnlockedState alloc] initWithDoorEntity:self]
        ]];
        
        [self addComponent:_intelligence];
        
        _animation = [[OGAnimationComponent alloc] init];
        [self addComponent:_animation];
        
        _lockComponent = [[OGLockComponent alloc] init];
        [self addComponent:_lockComponent];
    }
    
    return self;
}

- (void)lock
{
    self.lockComponent.locked = YES;
}

- (void)unlock
{
    self.lockComponent.locked = NO;
}

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    if ([entity isKindOfClass:OGPlayerEntity.self])
    {
        NSLog(@"open mf");
        
    }
}

- (void)contactWithEntityDidEnd:(GKEntity *)entity
{
    
}

+ (void)loadResourcesWithCompletionHandler:(void (^)(void))completionHandler
{
    [OGDoorEntity loadMiscellaneousAssets];
}

+ (void)loadMiscellaneousAssets
{
    NSArray *contactColliders = [NSArray arrayWithObject:[OGColliderType player]];
    [[OGColliderType requestedContactNotifications] setObject:contactColliders forKey:[OGColliderType door]];
}

@end
