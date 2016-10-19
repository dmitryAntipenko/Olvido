//
//  OGLightningScenePair.m
//  Olvido
//
//  Created by Алексей Подолян on 10/19/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLightningScenePair.h"
#import "OGSpriteNode.h"

NSString *const kOGLightningSceneParticleFileName = @"Lightning";
NSString *const kOGLightningSceneParticleFileExtension = @"sks";

@implementation OGLightningScenePair

+ (instancetype)pairWithSpriteNodeA:(OGSpriteNode *)spriteNodeA spriteNodeB:(OGSpriteNode *)spriteNodeB
{
    OGLightningScenePair *pair = [[self alloc] initWithSpriteNodeA:spriteNodeA spriteNodeB:spriteNodeB];
    
    if (pair)
    {
        [pair addChild:pair.lightningEmitter];
        [pair update];
    }
    
    return [pair autorelease];
}

- (instancetype)initWithSpriteNodeA:(OGSpriteNode *)spriteNodeA spriteNodeB:(OGSpriteNode *)spriteNodeB
{
    self = [self init];
    
    if (self)
    {
        _spriteNodeA = spriteNodeA;
        _spriteNodeB = spriteNodeB;
        
        NSString *lightnineEmitterFilePath = [[NSBundle mainBundle] pathForResource:kOGLightningSceneParticleFileName
                                                                             ofType:kOGLightningSceneParticleFileExtension];
        _lightningEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:lightnineEmitterFilePath];
        
        if (!_lightningEmitter)
        {
            [self release];
            self = nil;
        }
    }
    
    return self;
}

- (void)update
{
    CGFloat angle = atan((self.spriteNodeA.position.x - self.spriteNodeB.position.x) / (self.spriteNodeA.position.y - self.spriteNodeB.position.y));
    
    CGFloat distance = pow(pow(self.spriteNodeA.position.x - self.spriteNodeB.position.x, 2)
                           + pow(self.spriteNodeA.position.y - self.spriteNodeB.position.y, 2), 0.5);
    
    self.lightningEmitter.particlePositionRange = CGVectorMake(distance, 0.0);
    self.zRotation = angle;
}

- (BOOL)isEqual:(OGLightningScenePair *)object
{
    return ((self.spriteNodeA == object.spriteNodeA) && (self.spriteNodeB == object.spriteNodeB))
    || ((self.spriteNodeA == object.spriteNodeB) && (self.spriteNodeB == object.spriteNodeA));
}

@end



