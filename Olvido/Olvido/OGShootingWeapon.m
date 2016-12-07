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

#import "OGWeaponConfiguration.h"
#import "OGAudioConfiguration.h"

static NSArray *sOGWeaponEntitySoundNodes = nil;

@interface OGShootingWeapon () <OGResourceLoadable>

@property (nonatomic, strong) OGWeaponConfiguration *weaponConfiguration;
@property (nonatomic, strong) OGSoundComponent *soundComponent;
@property (nonatomic, weak, readonly) OGWeaponComponent *weaponComponent;

@end

@implementation OGShootingWeapon

#pragma mark - Initializing

- (instancetype)initWithSpriteNode:(SKSpriteNode *)sprite configuration:(OGWeaponConfiguration *)configuration
{
    self = [super initWithSpriteNode:sprite
                         attackSpeed:configuration.attackSpeed
                         reloadSpeed:configuration.reloadSpeed
                              charge:configuration.charge
                           maxCharge:configuration.maxCharge
                 inventoryIdentifier:configuration.identifier];
    
    if (self)
    {
        _weaponConfiguration = configuration;
        
        NSMutableArray<SKAudioNode *> *soundNodes = [NSMutableArray array];
        
        for (OGAudioConfiguration *audioConfiguration in _weaponConfiguration.audios)
        {
            SKAudioNode *node = [[SKAudioNode alloc] initWithFileNamed:audioConfiguration.audioName];
            node.autoplayLooped = audioConfiguration.repeatForever;
            node.name = audioConfiguration.key;
            
            if (node)
            {
                [soundNodes addObject:node];
            }
        }
        
        _soundComponent = [[OGSoundComponent alloc] initWithSoundNodes:soundNodes];
        [self addComponent:_soundComponent];
    }
    
    return self;
}

- (void)setOwner:(GKEntity *)owner
{
    super.owner = owner;
    
    self.soundComponent.target = ((OGRenderComponent *) [self.owner componentForClass:OGRenderComponent.self]).node;
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

- (void)attackWithVector:(CGVector)vector
{
    if (vector.dx != 0.0 && vector.dy != 0.0)
    {
        OGRenderComponent *ownerRenderComponent = (OGRenderComponent *) [self.owner componentForClass:[OGRenderComponent class]];
        
        if (ownerRenderComponent)
        {
            [self createBulletAtPoint:ownerRenderComponent.node.position withVector:vector];            
        }
    }
}

- (void)createBulletAtPoint:(CGPoint)point withVector:(CGVector)vector
{
    OGBullet *bullet = [[OGBullet alloc] initWithConfiguration:self.weaponConfiguration.shellConfiguration];
    
    bullet.renderComponent.node.position = point;
    
    CGFloat vectorAngle = atan2(-vector.dx, vector.dy);
    
    CGVector bulletMovementVector = CGVectorMake(-sinf(vectorAngle) * bullet.speed,
                                                 cosf(vectorAngle) * bullet.speed);
    
    bullet.renderComponent.node.zRotation = vectorAngle;
    bullet.delegate = self.delegate;
    bullet.weapon = self;
    [self.delegate addEntity:bullet];
    
    [bullet.physicsComponent.physicsBody applyImpulse:bulletMovementVector];
}

#pragma mark - Resources

+ (void)loadResourcesWithCompletionHandler:(void (^)())handler
{    
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
