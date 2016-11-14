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
#import "OGTransitionComponent.h"

#import "OGPlayerEntity.h"

#import "OGDoorEntityClosedState.h"
#import "OGDoorEntityOpenedState.h"
#import "OGDoorEntityLockedState.h"
#import "OGDoorEntityUnlockedState.h"

NSString *const kOGDoorEntityTriggerNodeName = @"trigger";

@implementation OGDoorEntity

- (instancetype)init
{
    self = [self initWithSpriteNode:nil];
    
    return self;
}

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
{
    if (spriteNode)
    {
        self = [super init];
        
        if (self)
        {
            [OGDoorEntity loadMiscellaneousAssets];
            
            _render = [[OGRenderComponent alloc] init];
            _render.node = spriteNode;
            [self addComponent:_render];
            
            SKNode *trigger = [spriteNode childNodeWithName:kOGDoorEntityTriggerNodeName];
            trigger.entity = self;
            _physics = [[OGPhysicsComponent alloc] initWithPhysicsBody:trigger.physicsBody
                                                          colliderType:[OGColliderType door]];
            [self addComponent:_physics];        
            
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
            
            _transition = [[OGTransitionComponent alloc] init];
            [self addComponent:_transition];
        }
    }
    else
    {
        self = nil;
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
        [self.transitionDelegate transitToDestinationWithTransitionComponent:self.transition completion:^()
         {
            [self swapTriggerPosition];
             
            SKNode *temp = self.transition.destination;
            self.transition.destination = self.transition.source;
            self.transition.source = temp;
        }];
    }
}

- (void)swapTriggerPosition
{
    SKNode *trigger = [self.render.node childNodeWithName:kOGDoorEntityTriggerNodeName];
    
    CGPoint newTriggerPosition = CGPointMake(-trigger.position.x, -trigger.position.y);
    
    SKAction *move = [SKAction moveTo:newTriggerPosition duration:0.0];
    [trigger runAction:move];
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

+ (BOOL)resourcesNeedLoading
{
    return YES;
}

+ (void)purgeResources
{
    return;
}

@end
