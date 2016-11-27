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

NSString *const OGTrailComponentParticleFileName = @"SlimeTrail";
CGFloat const OGTrailComponentParticleBirthratePlay = 120.0;
CGFloat const OGTrailComponentParticleBirthratePause = 0.0;
CGFloat const OGTrailComponentParticleAlphaRange = 0.2;
CGFloat const OGTrailComponentParticleAlpha = 0.5;
CGFloat const OGTrailComponentParticleSpeed = 0.0;
CGFloat const OGTrailComponentParticleLifeTime = 10.0;
CGFloat const OGTrailComponentParticleAngleRange = 0.0;
CGFloat const OGTrailComponentParticleScale = 0.6;
CGFloat const OGTrailComponentParticleScaleRange = 0.6;
CGFloat const OGTrailComponentParticlePsoitionRangeDx = 32.0;
CGFloat const OGTrailComponentParticlePsoitionRangeDy = 32.0;
CGFloat const OGTrailComponentParticleLifeTimeRange = 0.0;
CGFloat const OGTrailComponentParticleAlphaSpeed = -0.1;

@interface OGTrailComponent ()

@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) SKEmitterNode *emitter;
@property (nonatomic, assign, getter=isReady) BOOL ready;
@property (nonatomic, assign) CGPoint lastPosition;

@end

@implementation OGTrailComponent

@synthesize renderComponent = _renderComponent;

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _emitter = [SKEmitterNode node];
        _emitter.particleAlphaSpeed = OGTrailComponentParticleAlphaSpeed;
        _emitter.particleAlphaRange = OGTrailComponentParticleAlphaRange;
        _emitter.particleAlpha = OGTrailComponentParticleAlpha;
        _emitter.particleSpeed = OGTrailComponentParticleSpeed;
        _emitter.particleScale = OGTrailComponentParticleScale;
        _emitter.particleLifetime = OGTrailComponentParticleLifeTime;
        _emitter.emissionAngleRange = OGTrailComponentParticleAngleRange;
        _emitter.particlePositionRange = CGVectorMake(OGTrailComponentParticlePsoitionRangeDx, OGTrailComponentParticlePsoitionRangeDy);
        _emitter.particleScaleRange = OGTrailComponentParticleScaleRange;
        _emitter.particleLifetimeRange = OGTrailComponentParticleLifeTimeRange;
        _emitter.particleBirthRate = OGTrailComponentParticleBirthratePause;
    }
    
    return self;
}

- (void)didAddToEntity
{
    self.renderComponent = (OGRenderComponent *)[self.entity componentForClass:[OGRenderComponent class]];
    
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

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    
}

- (OGRenderComponent *)renderComponent
{
    if (!_renderComponent)
    {
        _renderComponent = (OGRenderComponent *)[self.entity componentForClass:[OGRenderComponent class]];
    }
    
    return _renderComponent;
}

- (void)pause
{
    self.emitter.particleBirthRate = OGTrailComponentParticleBirthratePause;
}

- (void)play
{
    self.emitter.particleBirthRate = OGTrailComponentParticleBirthratePlay;
}

- (void)setTargetNode:(SKNode *)targetNode
{
    _targetNode = targetNode;
    
    if (_targetNode)
    {
        self.emitter.targetNode = targetNode;
    }
    else
    {
        self.emitter.targetNode = self.renderComponent.node.scene;
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
    
    if (texture)
    {
        [self play];
    }
    else
    {
        [self pause];
    }
}

@end
