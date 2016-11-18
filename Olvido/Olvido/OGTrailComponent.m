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
CGFloat const kOGTrailComponentParticleBirthratePlay = 20.0;
CGFloat const kOGTrailComponentParticleBirthratePause = 0.0;

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
        _emitter.particleAlpha = 1.0;
        _emitter.particleSpeed = 0.0;
        _emitter.particleLifetime = 30.0;
        _emitter.particleAlphaRange = 0.0;
        _emitter.emissionAngleRange = 0.0;
        _emitter.particleScaleRange = 0.0;
        _emitter.particleLifetimeRange = 0.0;
        _emitter.particleBirthRate = 0.0;
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
