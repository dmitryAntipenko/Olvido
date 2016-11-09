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

#import "OGPlayerEntityConfiguration.h"
#import "OGAnimationState.h"

NSString *const kOGPlayerEntityAtlasNamesPlayerBotIdle = @"PlayerBotIdle";
NSString *const kOGPlayerEntityAtlasNamesPlayerBotWalk = @"PlayerBotWalk";

static NSDictionary *sAnimations;
static NSDictionary *sAppearTextures;

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
                                                      colliderType:_playerConfiguration.colliderType];
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
        
        _intelligence = [[OGIntelligenceComponent alloc] initWithStates:nil];
        [self addComponent:_intelligence];
        
        if (sAnimations)
        {
            _animation = [[OGAnimationComponent alloc] initWithTextureSize:_playerConfiguration.textureSize animations:sAnimations];
            //rewrite in Player Intelligence Component when write intelligenceComponent
            _animation.spriteNode = ((SKSpriteNode *)[_render.node children][0]);
            [self addComponent:_animation];
        }
        else
        {
            [NSException raise:@"Attempt to access sAnimations before they have been loaded" format:@"no loadedAnimation"];
            return nil;
        }
        
        SKSpriteNode *targetSprite = (SKSpriteNode *) _render.node.children.firstObject;
        _messageComponent = [[OGMessageComponent alloc] initWithTarget:targetSprite minShowDistance:_playerConfiguration.messageShowDistance];
        [self addComponent:_messageComponent];
    }
    
    return self;
}

+ (void)loadResourcesWithCompletionHandler:(void (^)(void))completionHandler
{
    NSArray *playerAtlasNames = @[kOGPlayerEntityAtlasNamesPlayerBotIdle,
                                  kOGPlayerEntityAtlasNamesPlayerBotWalk];
    
    [SKTextureAtlas preloadTextureAtlasesNamed:playerAtlasNames withCompletionHandler:^(NSError *error, NSArray<SKTextureAtlas *> *foundAtlases)
    {
        if (error)
        {
            [NSException raise:@"One or more texture atlases could not be found" format:@"%@", error];
        }
        
        NSMutableDictionary *appearTextures = [NSMutableDictionary dictionary];
        
        for (NSUInteger i = 0; i < kOGDirectionCount; i++)
        {
            appearTextures[kOGDirectionDescription[i]] = [OGAnimationComponent firstTextureForOrientationWithDirection:i
                                                                                                                 atlas:foundAtlases[0]
                                                                                                       imageIdentifier:kOGPlayerEntityAtlasNamesPlayerBotIdle];
        }
        
        sAppearTextures = appearTextures;
        
        NSMutableDictionary *animations = [NSMutableDictionary dictionary];
        
        animations[kOGAnimationStateDescription[kOGAnimationStateWalkForward]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[1]
                                                                                                           imageIdentifier:kOGPlayerEntityAtlasNamesPlayerBotWalk
                                                                                                            animationState:kOGAnimationStateWalkForward
                                                                                                            bodyActionName:nil
                                                                                                     repeatTexturesForever:YES
                                                                                                             playBackwards:NO];
        
        sAnimations = animations;
        
        completionHandler();
    }];
    
}

@end
