//
//  OGTorchComponent.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/18/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTorchComponent.h"
#import "SKColor+OGConstantColors.h"

NSString *const kOGTorchComponentLightImageName = @"LightImg";
NSString *const kOGTorchComponentLightName = @"light";

@interface OGTorchComponent ()

@property (nonatomic, getter=isTurnedOn) BOOL turnedOn;
@property (nonatomic, assign) SKNode *torchNode;

@end

@implementation OGTorchComponent

- (void)torchTurnOn
{
    if (!self.isTurnedOn)
    {
        SKSpriteNode *light = (SKSpriteNode *) [self.torchNode childNodeWithName:kOGTorchComponentLightName];
        
        if (light)
        {
            light.colorBlendFactor = 0.0;
            light.color = [SKColor clearColor];
        }
        else
        {
            [self createLight];
        }
    }
}

- (void)torchTurnOff
{
    SKSpriteNode *light = (SKSpriteNode *) [self.torchNode childNodeWithName:kOGTorchComponentLightName];
    
    if (light)
    {
        light.colorBlendFactor = 1.0;
        light.color = [SKColor gameBlack];
    }
}

- (void)createLight
{
    SKSpriteNode *light = [SKSpriteNode spriteNodeWithImageNamed:kOGTorchComponentLightImageName];
    light.size = CGSizeMake(self.torchDiameter, self.torchDiameter);
    light.name = kOGTorchComponentLightName;
    light.zPosition = 1;
    light.colorBlendFactor = 0.0;
    light.color = [SKColor gameBlack];
    
    [self.torchNode addChild:light];
}

- (SKNode *)torchNode
{
    return ((GKSKNodeComponent *)[self.entity componentForClass:[GKSKNodeComponent class]]).node;
}

- (CGFloat)torchDiameter
{
    return self.torchRadius * 2.0;
}
@end
