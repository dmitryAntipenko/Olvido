 //
//  OGBullet.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/13/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGBullet.h"
#import "OGMovementComponent.h"
#import "OGRenderComponent.h"
#import "OGAnimationComponent.h"
#import "OGPhysicsComponent.h"

#import "OGHealthComponentDelegate.h"
#import "OGShellConfiguration.h"

CGFloat const OGBulletEntityDefaultMass = 0.005;

@interface OGBullet ()

@property (nonatomic, strong) OGShellConfiguration *bulletConfiguration;

@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;
@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGHealthComponent *healthComponent;

@end

@implementation OGBullet

- (instancetype)initWithConfiguration:(OGShellConfiguration *)configuration
{
    self = [super init];
    
    if (self)
    {
        _bulletConfiguration = configuration;
        
        _renderComponent = [[OGRenderComponent alloc] init];
            
        SKSpriteNode *bulletSprite = [SKSpriteNode spriteNodeWithImageNamed:configuration.textureName];
        bulletSprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:bulletSprite.size.width / 2.0];
        bulletSprite.physicsBody.mass = OGBulletEntityDefaultMass;
        
        _renderComponent.node = bulletSprite;
        [self addComponent:_renderComponent];
        
        _physicsComponent = [[OGPhysicsComponent alloc] initWithPhysicsBody:_renderComponent.node.physicsBody
                                                               colliderType:configuration.colliderType];
        [self addComponent:_physicsComponent];
        
        _speed = configuration.speed;
    }
    
    return self;
}

#pragma mark - Contact Handling

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    if ([entity conformsToProtocol:@protocol(OGHealthComponentDelegate)])
    {
        [((id<OGHealthComponentDelegate>) entity) dealDamageToEntity:self.bulletConfiguration.damage];
    }
         
    [self.delegate removeEntity:self];
}

- (void)contactWithEntityDidEnd:(GKEntity *)entity
{
}

#pragma mark - Resources

+ (BOOL)resourcesNeedLoading
{
    return YES;
}

+ (void)loadResourcesWithCompletionHandler:(void (^)())handler
{
    [OGBullet loadMiscelaneousAssets];
    
    handler();        
}

+ (void)purgeResources
{
    
}

+ (void)loadMiscelaneousAssets
{
    NSArray *contactColliders = @[[OGColliderType obstacle], [OGColliderType door], [OGColliderType enemy]];
    [[OGColliderType requestedContactNotifications] setObject:contactColliders forKey:[OGColliderType bullet]];
    
    NSArray *enemyContactColliders = @[[OGColliderType obstacle], [OGColliderType door], [OGColliderType player]];
    [[OGColliderType requestedContactNotifications] setObject:enemyContactColliders forKey:[OGColliderType enemyBullet]];
}

@end
