//
//  OGBlaster.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/12/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGWeaponEntity.h"
#import "OGRenderComponent.h"
#import "OGPhysicsComponent.h"
#import "OGBullet.h"
#import "OGDeadBulletsManager.h"
#import "OGWeaponComponent.h"
#import "OGMovementComponent.h"

NSString *const kOGWeaponEntityDefaultInventoryIdentifier = @"weapon";
CGFloat const kOGWeaponEntityDefaultBulletSpeed = 10.0;
CGFloat const kOGWeaponEntityDefaultBulletLifetime = 0.3;
CGFloat const kOGWeaponEntityThrowingFactor = 80.0;

@interface OGWeaponEntity ()

@property (nonatomic, weak, readonly) OGWeaponComponent *weaponComponent;
@property (nonatomic, assign) BOOL allowsAttacking;
@property (nonatomic, strong) NSTimer *bulletSpawnTimer;

@end

@implementation OGWeaponEntity

- (instancetype)initWithSpriteNode:(SKSpriteNode *)sprite
{
    self = [super init];

    if (self)
    {
        NSMutableArray *collisionColliders = [NSMutableArray arrayWithObjects:[OGColliderType obstacle], nil];
        [[OGColliderType definedCollisions] setObject:collisionColliders forKey:[OGColliderType weapon]];
        
        _render = [[OGRenderComponent alloc] init];
        _render.node = sprite;
        [self addComponent:_render];
        
        _physics = [[OGPhysicsComponent alloc] initWithPhysicsBody:sprite.physicsBody
                                                      colliderType:[OGColliderType weapon]];
        [self addComponent:_physics];
        
        _allowsAttacking = YES;
    }
    
    return self;
}

#pragma mark - OGAttacking

- (void)attackWithVector:(CGVector)vector speed:(CGFloat)speed
{
    if (vector.dx != 0.0 && vector.dy != 0.0)
    {
        OGRenderComponent *ownerRenderComponent = (OGRenderComponent *) [self.owner componentForClass:OGRenderComponent.self];
        
        if (ownerRenderComponent)
        {
            self.allowsAttacking = NO;
            CGFloat vectorAngle = atan2(-vector.dx, vector.dy);
            
            CGVector bulletMovementVector = CGVectorMake(-sinf(vectorAngle) * kOGWeaponEntityDefaultBulletSpeed,
                                                         cosf(vectorAngle) * kOGWeaponEntityDefaultBulletSpeed);
            
            OGBullet *bullet = [self createBulletAtPoint:ownerRenderComponent.node.position
                                            withRotation:vectorAngle];
            
            [[OGDeadBulletsManager sharedManager] addItem:bullet];
            
            [ownerRenderComponent.node.scene addChild:bullet.render.node];
            [bullet.physics.physicsBody applyImpulse:bulletMovementVector];            
            
            self.bulletSpawnTimer = [NSTimer scheduledTimerWithTimeInterval:kOGWeaponEntityDefaultBulletLifetime repeats:NO block:^(NSTimer *timer)
            {
                self.allowsAttacking = YES;
                [timer invalidate];
                timer = nil;
            }];
        }
    }
}

- (OGBullet *)createBulletAtPoint:(CGPoint)point withRotation:(CGFloat)rotation
{
    OGBullet *bullet = [[OGBullet alloc] init];
    
    bullet.render.node.zRotation = rotation;
    bullet.render.node.position = point;
    
    return bullet;
}

- (BOOL)canAttack
{
    return self.allowsAttacking;
}

- (OGWeaponComponent *)weaponComponent
{
    return (OGWeaponComponent *) [self.owner componentForClass:OGWeaponComponent.self];
}

#pragma mark - OGInventoryItem

- (void)didThrown
{
    SKSpriteNode *weaponNode = (SKSpriteNode *) self.render.node;
    
    OGMovementComponent *ownerMovement = (OGMovementComponent *) [self.owner componentForClass:OGMovementComponent.self];
    SKNode *ownerNode = ((OGRenderComponent *) [self.owner componentForClass:OGRenderComponent.self]).node;
    
    weaponNode.position = ownerNode.position;
    
    [ownerNode.scene addChild:weaponNode];
    
    CGVector dropVector = CGVectorMake(-ownerMovement.displacementVector.dx * kOGWeaponEntityThrowingFactor,
                                       -ownerMovement.displacementVector.dy * kOGWeaponEntityThrowingFactor);
    
    [weaponNode.physicsBody applyImpulse:dropVector];
    
    self.owner = nil;
}

- (SKTexture *)texture
{
    return ((SKSpriteNode *)self.render.node).texture;
}

- (NSString *)identifier
{
    return kOGWeaponEntityDefaultInventoryIdentifier;
}

@end
