//
//  OGFlashlightComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 12/5/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGFlashlightComponent.h"
#import "OGRenderComponent.h"
#import "OGShadowComponent.h"
#import "OGLightBitMask.h"

@interface OGFlashlightComponent ()

@property (nonatomic, strong) SKLightNode *flashlight;
@property (nonatomic, weak) OGShadowComponent *shadowComponent;
@property (nonatomic, weak) OGRenderComponent *renderComponent;

@end

@implementation OGFlashlightComponent

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _flashlight = [[SKLightNode alloc] init];
        _flashlight.enabled = NO;
        _flashlight.lightColor = [SKColor colorWithRed:160/255 green:1 blue:1 alpha:1];
        _flashlight.ambientColor = [SKColor colorWithRed:17/255 green:42/255 blue:107/255 alpha:1];
        _flashlight.categoryBitMask = OGLightBitMaskDefault;
    }
    
    return self;
}

- (void)didAddToEntity
{
    [super didAddToEntity];
    
    [self.renderComponent.node addChild:self.flashlight];
}

- (void)turnOn
{
     self.flashlight.enabled = YES;
     self.shadowComponent.node.hidden = YES;
}

- (void)turnOff
{
    self.flashlight.enabled = NO;
    self.shadowComponent.node.hidden = NO;
}

- (OGShadowComponent *)shadowComponent
{
    if (!_shadowComponent)
    {
        _shadowComponent = (OGShadowComponent *) [self.entity componentForClass:[OGShadowComponent class]];
    }
    
    return _shadowComponent;
}

- (OGRenderComponent *)renderComponent
{
    if (!_renderComponent)
    {
        _renderComponent = (OGRenderComponent *) [self.entity componentForClass:[OGRenderComponent class]];
    }
    
    return _renderComponent;
}

@end
