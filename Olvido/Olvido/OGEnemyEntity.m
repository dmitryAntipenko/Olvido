//
//  OGEnemyEntity.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyEntity.h"
#import "OGEnemyConfiguration.h"
#import "OGRenderComponent.h"
#import "OGIntelligenceComponent.h"
#import "OGMovementComponent.h"
#import "OGAnimationComponent.h"
#import "OGPhysicsComponent.h"
#import "OGAttacking.h"

#import "OGEnemyEntityConfiguration.h"

NSString *const kOGEnemyEntityAtlasNamesEnemyIdle = @"EnemyIdle";
NSString *const kOGEnemyEntityAtlasNamesEnemyWalk = @"EnemyWalk";
CGFloat const kOGEnemyEntityPatrolPathRadius = 10;

static NSDictionary<NSString *, NSDictionary *> *sOGEnemyEntityAnimations;

@interface OGEnemyEntity ()

@property (nonatomic, strong) OGEnemyEntityConfiguration *enemyConfiguration;
@property (nonatomic, strong) NSArray<NSValue *> *points;

@property (nonatomic, assign) OGEnemyEntityMandate mandate;
@property (nonatomic, strong) GKBehavior *behaviorForCurrentMandate;

@end

@implementation OGEnemyEntity

- (instancetype)initWithConfiguration:(OGEnemyConfiguration *)configuration
{
    return [self initWithPoints:nil];
}

- (instancetype)initWithPoints:(NSArray<NSValue *> *)points
{
    self = [super init];
    
    if (self)
    {
        _points = points;
        
//        _enemyConfiguration = [[OGEnemyEntityConfiguration alloc] init];
//        [self loadMiscellaneousAssets];
//        
//        _render = [[OGRenderComponent alloc] init];
//        [self addComponent:_render];
//        
//        _physics = [[OGPhysicsComponent alloc] initWithPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:configuration.physicsBodyRadius]
//                                                      colliderType:[OGColliderType enemy]];
        [self addComponent:_physics];
        
        _render.node.physicsBody = _physics.physicsBody;
        _render.node.physicsBody.allowsRotation = NO;
        
        _movement = [[OGMovementComponent alloc] init];
        [self addComponent:_movement];
        
        _intelligence = [[OGIntelligenceComponent alloc] initWithStates:nil];
        //[self addComponent:_intelligence];
        
        _animation = [[OGAnimationComponent alloc] init];
        [self addComponent:_animation];
    }
    
    return self;
}

+ (BOOL)resourcesNeedLoading
{
    return sOGEnemyEntityAnimations == nil;
}

+ (void)loadResourcesWithCompletionHandler:(void (^)())completionHandler
{
    [OGEnemyEntity loadMiscellaneousAssets];
    
    NSArray *enemyAtlasNames = @[kOGEnemyEntityAtlasNamesEnemyIdle,
                                 kOGEnemyEntityAtlasNamesEnemyWalk];
    
    [SKTextureAtlas preloadTextureAtlasesNamed:enemyAtlasNames withCompletionHandler:^(NSError *error, NSArray<SKTextureAtlas *> *foundAtlases)
    {
        NSMutableDictionary *animations = [NSMutableDictionary dictionary];
        
        animations[kOGAnimationStateDescription[kOGAnimationStateIdle]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[0]
                                                                                                    imageIdentifier:kOGEnemyEntityAtlasNamesEnemyIdle
                                                                                                     animationState:kOGAnimationStateIdle
                                                                                                     bodyActionName:nil
                                                                                              repeatTexturesForever:YES
                                                                                                      playBackwards:NO];
        
        animations[kOGAnimationStateDescription[kOGAnimationStateWalkForward]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[1]
                                                                                                           imageIdentifier:kOGEnemyEntityAtlasNamesEnemyWalk
                                                                                                            animationState:kOGAnimationStateWalkForward
                                                                                                            bodyActionName:nil
                                                                                                     repeatTexturesForever:YES
                                                                                                             playBackwards:NO];
        
        sOGEnemyEntityAnimations = animations;
        
        completionHandler();
    }];
}

+ (void)purgeResources
{
    sOGEnemyEntityAnimations = nil;
}

+ (void)loadMiscellaneousAssets
{
    NSArray *collisionColliders = [NSArray arrayWithObject:[OGColliderType obstacle]];
    [[OGColliderType definedCollisions] setObject:collisionColliders forKey:[OGColliderType enemy]];

    NSArray *contactColliders = [NSArray arrayWithObject:[OGColliderType player]];
    [[OGColliderType requestedContactNotifications] setObject:contactColliders forKey:[OGColliderType enemy]];
}

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{

}

+ (CGSize)textureSize
{
    return CGSizeMake(120.0, 120.0);
}

+ (NSDictionary *)sOGEnemyEntityAnimations
{
    return sOGEnemyEntityAnimations;
}

- (GKBehavior *)behaviorForCurrentMandate
{
    GKBehavior *result = nil;
    
    SKScene *scene = ((OGRenderComponent *) [self componentForClass:OGRenderComponent.self]).node.scene;
    
    if (!scene)
    {
        result = [[GKBehavior alloc] init];
    }
    else{
        
        CGFloat radius;
    
        switch (self.mandate) {
            case kOGEnemyEntityMandateFollowPath:
            {
                radius = kOGEnemyEntityPatrolPathRadius;
                break;
            }
            case kOGEnemyEntityMandateHunt:
            {
                break;
            }
            case kOGEnemyEntityMandateAttack:
            {
                break;
            }
            default:
                break;
        }
    
    }
    
    return result;
}

- (GKAgent2D *)agent
{
    if (!_agent)
    {
        _agent = (GKAgent2D *)[self componentForClass:GKAgent2D.self];
    }
    
    return _agent;
}

- (CGFloat)distanceToAgentWithOtherAgent:(GKAgent2D *)otherAgent
{
    CGFloat deltaX = self.agent.position.x - otherAgent.position.x;
    CGFloat deltaY = self.agent.position.y - otherAgent.position.y;
    
    return hypot(deltaX, deltaY);
}


@end
