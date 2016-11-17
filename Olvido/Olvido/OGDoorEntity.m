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
#import "OGInventoryComponent.h"

#import "OGDoorEntityClosedState.h"
#import "OGDoorEntityOpenedState.h"
#import "OGDoorEntityLockedState.h"
#import "OGDoorEntityUnlockedState.h"

NSString *const kOGDoorEntityTriggerNodeName = @"trigger";

@interface OGDoorEntity ()

@property (nonatomic, strong) NSMutableArray<NSString *> *keyIdentifiers;

@end

@implementation OGDoorEntity

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
{
    if (spriteNode)
    {
        self = [super init];
        
        if (self)
        {
            _keyIdentifiers = [NSMutableArray array];
            
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
    if ([entity isKindOfClass:self.lockComponent.target.entity.class])
    {
        if (!self.lockComponent.isLocked)
        {
            [self.transitionDelegate transitToDestinationWithTransitionComponent:self.transition completion:^()
             {
                [self swapTriggerPosition];
                 
                SKNode *temp = self.transition.destination;
                self.transition.destination = self.transition.source;
                self.transition.source = temp;
            }];
        }
        else
        {
            OGInventoryComponent *inventory = (OGInventoryComponent *) [entity componentForClass:OGInventoryComponent.self];
            
            for (NSString *identifier in self.keyIdentifiers)
            {
                if ([inventory containsItemWithIdentifier:identifier])
                {
                    self.lockComponent.locked = NO;
                    break;
                }
            }
        }
    }
}

- (void)swapTriggerPosition
{
    SKNode *trigger = [self.render.node childNodeWithName:kOGDoorEntityTriggerNodeName];
    
    CGPoint newTriggerPosition = CGPointMake(-trigger.position.x, -trigger.position.y);
    
    SKAction *move = [SKAction moveTo:newTriggerPosition duration:0.0];
    [trigger runAction:move];
}

- (void)addKeyName:(NSString *)keyName
{
    if (keyName)
    {
        [self.keyIdentifiers addObject:keyName];
    }
}

- (void)removeKeyName:(NSString *)keyName
{
    if (keyName)
    {
        [self.keyIdentifiers removeObject:keyName];
    }
}

+ (void)loadResourcesWithCompletionHandler:(void (^)())handler
{
    [OGDoorEntity loadMiscellaneousAssets];
    
    handler();
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
