//
//  OGTrailComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTrailComponent.h"
#import "OGRenderComponent.h"
#import "OGZPositionEnum.m"

NSString *const kOGTrailComponentParticleFileName = @"SlimeTrail";
CGFloat const kOGTrailComponentParticleBirthratePlay = 60.0;
CGFloat const kOGTrailComponentParticleBirthratePause = 0.0;
CGFloat const kOGTrailComponentParticleAlphaRange = 0.2;
CGFloat const kOGTrailComponentParticleAlpha = 0.8;
CGFloat const kOGTrailComponentParticleSpeed = 0.0;
CGFloat const kOGTrailComponentParticleLifeTime = 30.0;
CGFloat const kOGTrailComponentParticleAngleRange = 0.0;
CGFloat const kOGTrailComponentParticlePsoitionRangeDx = 20.0;
CGFloat const kOGTrailComponentParticlePsoitionRangeDy = 20.0;
CGFloat const kOGTrailComponentParticleScaleRange = 0.8;
CGFloat const kOGTrailComponentParticleLifeTimeRange = 0.0;


@interface OGTrailComponent ()

@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) SKEmitterNode *emitter;
@property (nonatomic, assign, getter=isReady) BOOL ready;

@end

@implementation OGTrailComponent

@synthesize renderComponent = _renderComponent;

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _emitter = [SKEmitterNode node];
        _emitter.particleAlphaRange = kOGTrailComponentParticleAlphaRange;
        _emitter.particleAlpha = kOGTrailComponentParticleAlpha;
        _emitter.particleSpeed = kOGTrailComponentParticleSpeed;
        _emitter.particleLifetime = kOGTrailComponentParticleLifeTime;
        _emitter.emissionAngleRange = kOGTrailComponentParticleAngleRange;
        _emitter.particlePositionRange = CGVectorMake(kOGTrailComponentParticlePsoitionRangeDx, kOGTrailComponentParticlePsoitionRangeDy);
        _emitter.particleScaleRange = kOGTrailComponentParticleScaleRange;
        _emitter.particleLifetimeRange = kOGTrailComponentParticleLifeTimeRange;
        _emitter.particleBirthRate = kOGTrailComponentParticleBirthratePause;
    }
    
    return self;
}

- (void)didAddToEntity
{
    self.renderComponent = (OGRenderComponent *)[self.entity componentForClass:OGRenderComponent.self];
    
    if (self.renderComponent)
    {
        [self.renderComponent.node addChild:self.emitter];
        self.emitter.particleZPosition = OGZPositionCategoryUnderPhysicsWorld;
    }
}

+ (instancetype)trailComponent
{
    return [[self alloc] init];
}

- (OGRenderComponent *)renderComponent
{
    if (!_renderComponent)
    {
        _renderComponent = (OGRenderComponent *)[self.entity componentForClass:OGRenderComponent.self];
    }
    
    return _renderComponent;
}

- (void)pause
{
    self.emitter.particleBirthRate = kOGTrailComponentParticleBirthratePause;
}

- (void)play
{
    self.emitter.particleBirthRate = kOGTrailComponentParticleBirthratePlay;
}

- (void)setTargetNode:(SKNode *)targetNode
{
    _targetNode = targetNode;
    
    if (_targetNode)
    {
        self.emitter.targetNode = targetNode;
        
        if (self.texture)
        {
            [self play];
        }
    }
    else
    {
        [self pause];
    }
}

- (void)setTextureSize:(CGSize)textureSize
{
    self.emitter.particleSize = textureSize;
}

- (void)setTexture:(SKTexture *)texture
{
    _texture = texture;
    self.emitter.particleTexture = texture;
    
    if (texture && self.targetNode )
    {
        [self play];
    }
    else
    {
        [self pause];
    }
}

@end
