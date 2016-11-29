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

NSString *const OGBulletTextureName = @"Bullet";
NSInteger const OGBulletDamage = 1;

CGFloat const OGBulletEntityDefaultSpeed = 10.0;

static SKTexture *sOGBulletEntityTexture;

@interface OGBullet ()

@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;
@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGHealthComponent *healthComponent;

@end

@implementation OGBullet

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _renderComponent = [[OGRenderComponent alloc] init];
            
        SKSpriteNode *bulletSprite = [SKSpriteNode spriteNodeWithTexture:sOGBulletEntityTexture];
        bulletSprite.physicsBody = [SKPhysicsBody bodyWithTexture:sOGBulletEntityTexture size:sOGBulletEntityTexture.size];
        
        _renderComponent.node = bulletSprite;
        [self addComponent:_renderComponent];
        
        _physicsComponent = [[OGPhysicsComponent alloc] initWithPhysicsBody:_renderComponent.node.physicsBody
                                                               colliderType:[OGColliderType bullet]];
        
        _speed = OGBulletEntityDefaultSpeed;
    }
    
    return self;
}

#pragma mark - Contact Handling

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    if ([entity conformsToProtocol:@protocol(OGHealthComponentDelegate)])
    {
        [((id<OGHealthComponentDelegate>) entity) dealDamageToEntity:OGBulletDamage];
    }
         
    [self.delegate removeEntity:self];
}

- (void)contactWithEntityDidEnd:(GKEntity *)entity
{
}

#pragma mark - Resources

+ (BOOL)resourcesNeedLoading
{
    return sOGBulletEntityTexture == nil;
}

+ (void)loadResourcesWithCompletionHandler:(void (^)())handler
{
    [OGBullet loadMiscelaneousAssets];
    
    sOGBulletEntityTexture = [SKTexture textureWithImageNamed:OGBulletTextureName];
    
    handler();        
}

+ (void)purgeResources
{
    sOGBulletEntityTexture = nil;
}

+ (void)loadMiscelaneousAssets
{
    NSArray *contactColliders = @[[OGColliderType obstacle], [OGColliderType door], [OGColliderType enemy]];
    [[OGColliderType requestedContactNotifications] setObject:contactColliders forKey:[OGColliderType bullet]];
}

@end
