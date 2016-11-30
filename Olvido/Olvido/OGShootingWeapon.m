//
//  OGShootingWeapon.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/29/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGShootingWeapon.h"
#import "OGBullet.h"
#import "OGRenderComponent.h"
#import "OGPhysicsComponent.h"
#import "OGSoundComponent.h"
#import "OGWeaponComponent.h"

static NSArray *sOGWeaponEntitySoundNodes = nil;

@interface OGShootingWeapon () <OGResourceLoadable>

@property (nonatomic, strong) OGSoundComponent *soundComponent;
@property (nonatomic, weak, readonly) OGWeaponComponent *weaponComponent;

@end

@implementation OGShootingWeapon

#pragma mark - Initializing

- (instancetype)initWithSpriteNode:(SKSpriteNode *)sprite attackSpeed:(CGFloat)attackSpeed reloadSpeed:(CGFloat)reloadSpeed charge:(NSUInteger)charge
{
    self = [super initWithSpriteNode:sprite attackSpeed:attackSpeed reloadSpeed:reloadSpeed charge:charge];
    
    if (self)
    {
        _soundComponent = [[OGSoundComponent alloc] initWithSoundNodes:sOGWeaponEntitySoundNodes];
        [self addComponent:_soundComponent];
    }
    
    return self;
}

- (OGWeaponComponent *)weaponComponent
{
    return (OGWeaponComponent *) [self.owner componentForClass:[OGWeaponComponent class]];
}

- (void)wasTaken
{
    [super wasTaken];
    
    [self.weaponComponent.weaponObserver weaponWasTakenWithProperties:@{@"Charge" : @(self.charge)}];
}

- (void)didThrown
{
    [super didThrown];
    
    [self.weaponComponent.weaponObserver weaponWasRemoved];
}

#pragma mark - OGAttacking

- (void)attackWithVector:(CGVector)vector speed:(CGFloat)speed
{
    if (vector.dx != 0.0 && vector.dy != 0.0)
    {
        OGRenderComponent *ownerRenderComponent = (OGRenderComponent *) [self.owner componentForClass:[OGRenderComponent class]];
        
        if (ownerRenderComponent)
        {
            [self createBulletAtPoint:ownerRenderComponent.node.position withVector:vector];
            
            [self.soundComponent playSoundOnce:@"shot"];
        }
    }
}

- (void)createBulletAtPoint:(CGPoint)point withVector:(CGVector)vector
{
    OGBullet *bullet = [[OGBullet alloc] init];
    
    bullet.renderComponent.node.position = point;
    
    CGFloat vectorAngle = atan2(-vector.dx, vector.dy);
    
    CGVector bulletMovementVector = CGVectorMake(-sinf(vectorAngle) * bullet.speed,
                                                 cosf(vectorAngle) * bullet.speed);
    
    bullet.renderComponent.node.zRotation = vectorAngle;
    bullet.delegate = self.delegate;
    [self.delegate addEntity:bullet];
    
    [bullet.physicsComponent.physicsBody applyImpulse:bulletMovementVector];
}

#pragma mark - Resources

+ (void)loadResourcesWithCompletionHandler:(void (^)())handler
{
    SKAudioNode *shotNode = [[SKAudioNode alloc] initWithFileNamed:@"shot"];
    shotNode.autoplayLooped = NO;
    shotNode.name = @"shot";
    
    sOGWeaponEntitySoundNodes = @[shotNode];
    
    handler();
}

+ (BOOL)resourcesNeedLoading
{
    return sOGWeaponEntitySoundNodes == nil;
}

+ (void)purgeResources
{
    sOGWeaponEntitySoundNodes = nil;
}

@end
