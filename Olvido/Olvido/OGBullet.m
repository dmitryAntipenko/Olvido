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
#import "OGDeadBulletsManager.h"

NSString *const kOGBulletTextureName = @"Bullet";

static SKTexture *sOGBulletEntityTexture;

@implementation OGBullet

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _render = [[OGRenderComponent alloc] init];
            
        SKSpriteNode *bulletSprite = [SKSpriteNode spriteNodeWithTexture:sOGBulletEntityTexture];
        bulletSprite.physicsBody = [SKPhysicsBody bodyWithTexture:sOGBulletEntityTexture size:sOGBulletEntityTexture.size];
        
        _render.node = bulletSprite;
        [self addComponent:_render];
        
        _physics = [[OGPhysicsComponent alloc] initWithPhysicsBody:_render.node.physicsBody
                                                      colliderType:[OGColliderType bullet]];
    }
    
    return self;
}

#pragma mark - Contact Handling

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    [self.render.node removeFromParent];
    [[OGDeadBulletsManager sharedManager] removeItem:self];
}

#pragma mark - Resources

+ (BOOL)resourcesNeedLoading
{
    return sOGBulletEntityTexture == nil;
}

+ (void)loadResourcesWithCompletionHandler:(void (^)())handler
{
    [OGBullet loadMiscelaneousAssets];
    
    sOGBulletEntityTexture = [SKTexture textureWithImageNamed:kOGBulletTextureName];
    
    handler();
}

+ (void)purgeResources
{
    sOGBulletEntityTexture = nil;
}

+ (void)loadMiscelaneousAssets
{
    NSArray *contactColliders = [NSArray arrayWithObjects:[OGColliderType obstacle], [OGColliderType door], [OGColliderType enemy], nil];
    [[OGColliderType requestedContactNotifications] setObject:contactColliders forKey:[OGColliderType bullet]];
}

@end
