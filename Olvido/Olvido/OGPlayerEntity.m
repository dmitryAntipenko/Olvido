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

@end

@implementation OGPlayerEntity

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
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

- (void)purgeResources
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

<<<<<<< HEAD

- (void)loadMiscellaneousAssets
=======
+ (void)loadMiscellaneousAssets
>>>>>>> PlayerIntelligence
{
    NSArray *collisionColliders = [NSArray arrayWithObject:[OGColliderType obstacle]];
    [[OGColliderType definedCollisions] setObject:collisionColliders forKey:[OGColliderType player]];
}

@end
