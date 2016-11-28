//
//  OGDoorEntity.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGZPositionEnum.m"
#import "OGDoorEntity.h"
#import "OGColliderType.h"
#import "OGRenderComponent.h"
#import "OGIntelligenceComponent.h"
#import "OGAnimationComponent.h"
#import "OGPhysicsComponent.h"
#import "OGLockComponent.h"
#import "OGTransitionComponent.h"
#import "OGInventoryComponent.h"
#import "OGSoundComponent.h"
#import "OGKeyComponent.h"

#import "OGDoorEntityClosedState.h"
#import "OGDoorEntityOpenedState.h"
#import "OGDoorEntityLockedState.h"
#import "OGDoorEntityUnlockedState.h"

NSString *const OGDoorEntityTriggerNodeName = @"trigger";

static NSArray *sOGDoorEntitySoundNodes = nil;

@interface OGDoorEntity ()

@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGIntelligenceComponent *intelligenceComponent;
@property (nonatomic, strong) OGAnimationComponent *animationComponent;
@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;
@property (nonatomic, strong) OGLockComponent *lockComponent;
@property (nonatomic, strong) OGTransitionComponent *transitionComponent;
@property (nonatomic, strong) OGSoundComponent *soundComponent;

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
            
            _renderComponent = [[OGRenderComponent alloc] init];
            _renderComponent.node = spriteNode;
            [self addComponent:_renderComponent];
            
            SKNode *trigger = [spriteNode childNodeWithName:OGDoorEntityTriggerNodeName];
            trigger.entity = self;
            _physicsComponent = [[OGPhysicsComponent alloc] initWithPhysicsBody:trigger.physicsBody
                                                                   colliderType:[OGColliderType doorTrigger]];
            [self addComponent:_physicsComponent];
            
            _intelligenceComponent = [[OGIntelligenceComponent alloc] initWithStates:@[
                [[OGDoorEntityClosedState alloc] initWithDoorEntity:self],
                [[OGDoorEntityOpenedState alloc] initWithDoorEntity:self],
                [[OGDoorEntityLockedState alloc] initWithDoorEntity:self],
                [[OGDoorEntityUnlockedState alloc] initWithDoorEntity:self]
            ]];
            
            [self addComponent:_intelligenceComponent];
            
            _animationComponent = [[OGAnimationComponent alloc] init];
            [self addComponent:_animationComponent];
            
            _lockComponent = [[OGLockComponent alloc] init];
            [self addComponent:_lockComponent];
            
            _transitionComponent = [[OGTransitionComponent alloc] init];
            [self addComponent:_transitionComponent];
            
            _soundComponent = [[OGSoundComponent alloc] initWithSoundNodes:sOGDoorEntitySoundNodes];
            _soundComponent.target = _renderComponent.node;
            [self addComponent:_soundComponent];
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
            [self.transitionDelegate transitToDestinationWithTransitionComponent:self.transitionComponent completion:^()
             {
                [self swapTriggerPosition];
                 
                SKNode *temp = self.transitionComponent.destination;
                self.transitionComponent.destination = self.transitionComponent.source;
                self.transitionComponent.source = temp;
            }];
        }
        else
        {
            OGInventoryComponent *inventory = (OGInventoryComponent *) [entity componentForClass:[OGInventoryComponent class]];
            
            for (GKEntity *entity in inventory.inventoryItems)
            {
                OGKeyComponent *keyComponent = (OGKeyComponent *) [entity componentForClass:[OGKeyComponent class]];
                
                if (keyComponent)
                {
                    if ([self.keyIdentifiers containsObject:keyComponent.keyIdentifier])
                    {
                        self.lockComponent.locked = NO;
                        break;
                    }
                }
            }
        }
    }
}

- (void)contactWithEntityDidEnd:(GKEntity *)entity
{
}

- (void)swapTriggerPosition
{
    SKNode *trigger = [self.renderComponent.node childNodeWithName:OGDoorEntityTriggerNodeName];
    
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
    
    SKAudioNode *doorOpenNode = [[SKAudioNode alloc] initWithFileNamed:@"door_open"];
    doorOpenNode.autoplayLooped = NO;
    doorOpenNode.name = @"door_open";
    
    sOGDoorEntitySoundNodes = @[doorOpenNode];
    
    handler();
}

+ (void)loadMiscellaneousAssets
{
    NSArray *contactColliders = @[[OGColliderType player]];
    [[OGColliderType requestedContactNotifications] setObject:contactColliders forKey:[OGColliderType doorTrigger]];
    [[OGColliderType requestedContactNotifications] setObject:contactColliders forKey:[OGColliderType door]];
}

+ (BOOL)resourcesNeedLoading
{
    return YES;
}

+ (void)purgeResources
{
    sOGDoorEntitySoundNodes = nil;
}

@end
