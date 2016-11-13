//
//  OGPlayerEntity.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerEntity.h"
#import "OGRenderComponent.h"
#import "OGHealthComponent.h"
#import "OGIntelligenceComponent.h"
#import "OGInputComponent.h"
#import "OGMovementComponent.h"
#import "OGAnimationComponent.h"
#import "OGPhysicsComponent.h"
#import "OGMessageComponent.h"
#import "OGOrientationComponent.h"
#import "OGWeaponComponent.h"
#import "OGInventory.h"
#import "OGInventoryItemProtocol.h"

#import "OGColliderType.h"

#import "OGPlayerEntityConfiguration.h"
#import "OGAnimationState.h"

#import "OGPlayerEntityAppearState.h"
#import "OGplayerEntityControlledState.h"
#import "OGplayerEntityAttackState.h"

NSString *const kOGPlayerEntityAtlasNamesPlayerBotIdle = @"PlayerBotIdle";
NSString *const kOGPlayerEntityAtlasNamesPlayerBotWalk = @"PlayerBotWalk";

static NSDictionary<NSString *, NSDictionary *> *sOGPlayerEntityAnimations;
static NSDictionary<NSString *, SKTexture *> *sOGPlayerEntityAppearTextures;

@interface OGPlayerEntity ()

@property (nonatomic, strong) OGPlayerEntityConfiguration *playerConfiguration;
@property (nonatomic, assign) BOOL canTakeWeapon;

@end

@implementation OGPlayerEntity

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _inventory = [[OGInventory alloc] init];
        
        _playerConfiguration = [[OGPlayerEntityConfiguration alloc] init];
        
        _render = [[OGRenderComponent alloc] init];
        [self addComponent:_render];
        
        _physics = [[OGPhysicsComponent alloc] initWithPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:_playerConfiguration.physicsBodyRadius]
                                                      colliderType:[OGColliderType player]];
        [self addComponent:_physics];
        
        _render.node.physicsBody = _physics.physicsBody;
        _render.node.physicsBody.allowsRotation = NO;
        
        _health = [[OGHealthComponent alloc] init];
        _health.maxHealth = _playerConfiguration.maxHealth;
        _health.currentHealth = _playerConfiguration.currentHealth;
        [self addComponent:_health];
        
        _movement = [[OGMovementComponent alloc] init];
        [self addComponent:_movement];
        
        _input = [[OGInputComponent alloc] init];
        _input.enabled = YES;
        [self addComponent:_input];
        
        OGPlayerEntityAppearState *appearState = [[OGPlayerEntityAppearState alloc] initWithPlayerEntity:self];
        OGPlayerEntityControlledState *controlledState = [[OGPlayerEntityControlledState alloc] initWithPlayerEntity:self];
        OGPlayerEntityAttackState *attackState = [[OGPlayerEntityAttackState alloc] initWithPlayerEntity:self];
        
        NSArray *states = @[appearState, controlledState, attackState];
        
        _intelligence = [[OGIntelligenceComponent alloc] initWithStates:states];
        [self addComponent:_intelligence];
        
        if (sOGPlayerEntityAnimations)
        {
            _animation = [[OGAnimationComponent alloc] initWithTextureSize:[OGPlayerEntity textureSize] animations:sOGPlayerEntityAnimations];
            [_render.node addChild:_animation.spriteNode];
            [self addComponent:_animation];
        }
        else
        {
            return nil;
        }
        
        _orientation = [[OGOrientationComponent alloc] init];
        [self addComponent:_orientation];
        
        SKSpriteNode *targetSprite = (SKSpriteNode *) _render.node.children.firstObject;
        _messageComponent = [[OGMessageComponent alloc] initWithTarget:targetSprite minShowDistance:_playerConfiguration.messageShowDistance];
        [self addComponent:_messageComponent];
        
        _weaponComponent = [[OGWeaponComponent alloc] init];
        [self addComponent:_weaponComponent];
        
        _canTakeWeapon = YES;
    }
    
    return self;
}

+ (BOOL)resourcesNeedLoading
{
    return sOGPlayerEntityAnimations == nil || sOGPlayerEntityAppearTextures == nil;
}

+ (void)loadResourcesWithCompletionHandler:(void (^)(void))completionHandler
{
    [OGPlayerEntity loadMiscellaneousAssets];
    
    NSArray *playerAtlasNames = @[kOGPlayerEntityAtlasNamesPlayerBotIdle,
                                  kOGPlayerEntityAtlasNamesPlayerBotWalk];
    
    [SKTextureAtlas preloadTextureAtlasesNamed:playerAtlasNames withCompletionHandler:^(NSError *error, NSArray<SKTextureAtlas *> *foundAtlases)
    {
        NSMutableDictionary *appearTextures = [NSMutableDictionary dictionary];
        
        for (NSUInteger i = 0; i < kOGDirectionCount; i++)
        {
            appearTextures[kOGDirectionDescription[i]] = [OGAnimationComponent firstTextureForOrientationWithDirection:i
                                                                                                                 atlas:foundAtlases[0]
                                                                                                       imageIdentifier:kOGPlayerEntityAtlasNamesPlayerBotIdle];
        }
        
        sOGPlayerEntityAppearTextures = appearTextures;
        
        NSMutableDictionary *animations = [NSMutableDictionary dictionary];
        
        animations[kOGAnimationStateDescription[kOGAnimationStateIdle]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[0]
                                                                                                           imageIdentifier:kOGPlayerEntityAtlasNamesPlayerBotIdle
                                                                                                            animationState:kOGAnimationStateIdle
                                                                                                            bodyActionName:nil
                                                                                                     repeatTexturesForever:YES
                                                                                                             playBackwards:NO];
        
        animations[kOGAnimationStateDescription[kOGAnimationStateWalkForward]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[1]
                                                                                                           imageIdentifier:kOGPlayerEntityAtlasNamesPlayerBotWalk
                                                                                                            animationState:kOGAnimationStateWalkForward
                                                                                                            bodyActionName:nil
                                                                                                     repeatTexturesForever:YES
                                                                                                             playBackwards:NO];
        
        sOGPlayerEntityAnimations = animations;
        
        completionHandler();
    }];
}

+ (void)purgeResources
{
    sOGPlayerEntityAppearTextures = nil;
    sOGPlayerEntityAnimations = nil;
}

+ (NSDictionary *)sOGPlayerEntityAnimations
{
    return sOGPlayerEntityAnimations;
}

+ (NSDictionary *)sOGPlayerEntityAppearTextures
{
    return sOGPlayerEntityAppearTextures;
}

+ (CGSize)textureSize
{
    return CGSizeMake(120.0, 120.0);
}

+ (void)loadMiscellaneousAssets
{
    NSMutableArray *collisionColliders = [NSMutableArray arrayWithObjects:[OGColliderType obstacle], nil];
    [[OGColliderType definedCollisions] setObject:collisionColliders forKey:[OGColliderType player]];
    
    NSArray *contactColliders = [NSArray arrayWithObject:[OGColliderType weapon]];
    [[OGColliderType requestedContactNotifications] setObject:contactColliders forKey:[OGColliderType player]];
}

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    if ([entity conformsToProtocol:@protocol(OGAttacking)] && self.canTakeWeapon)
    {
        OGRenderComponent *renderComponent = (OGRenderComponent *) [entity componentForClass:OGRenderComponent.self];
     
        [self dropCurrentWeaponAtPoint:renderComponent.node.position];
        
        if (renderComponent)
        {
            self.weaponComponent.weapon = (OGWeaponEntity *) entity;
            [self.inventory addItem:(id<OGInventoryItemProtocol>) entity];
            [renderComponent.node removeFromParent];
            
            SKAction *takeWeaponDelay = [SKAction waitForDuration:1.0];
            [self.render.node runAction:takeWeaponDelay completion:^()
            {
                self.canTakeWeapon = YES;
            }];
        }
    }
}

- (void)dropCurrentWeaponAtPoint:(CGPoint)point
{
    if (self.weaponComponent.weapon)
    {
        SKSpriteNode *weaponNode = (SKSpriteNode *) self.weaponComponent.weapon.render.node;
        
        CGPoint playerPosition = self.render.node.position;
        
        weaponNode.position = point;
        
        [self.render.node.scene addChild:weaponNode];
        
        //CGVector dropVector = CGVectorMake(weaponNode.position.x - playerPosition.x,
          //                                 weaponNode.position.y - playerPosition.y);
        
        //[weaponNode.physicsBody applyImpulse:dropVector];
        
        self.canTakeWeapon = NO;
        [self.inventory removeItem:self.weaponComponent.weapon];
        self.weaponComponent.weapon = nil;
    }
}

- (void)contactWithEntityDidEnd:(GKEntity *)entity
{
    
}

@end
