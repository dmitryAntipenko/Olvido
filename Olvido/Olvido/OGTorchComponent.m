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

@property (nonatomic, retain) SKSpriteNode *torchSprite;
@property (nonatomic, getter=isTurnedOn) BOOL *turnedOn;

@end

@implementation OGTorchComponent

- (instancetype)initWithTorchSprite:(SKSpriteNode *)torchSprite
                             tourchRadius:(CGFloat)torchRadius
{
    self = [super init];
    
    if (self)
    {
        _torchSprite = [torchSprite retain];
        _torchRadius = torchRadius;
        _turnedOn = NO;
    }
    else
    {
        [self release];
        self = nil;
    }
    
    return self;
}

- (void)torchTurnOn
{
    if (!self.isTurnedOn)
    {
        SKSpriteNode *light = (SKSpriteNode *)[self.torchSprite childNodeWithName:kOGTorchComponentLightName];
        
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
    SKSpriteNode *light = (SKSpriteNode *)[self.torchSprite childNodeWithName:kOGTorchComponentLightName];
    
    if (light)
    {
        light.colorBlendFactor = 1.0;
        light.color = [SKColor gameBlue];
    }
}

- (void)createLight
{
    SKSpriteNode *light = [SKSpriteNode spriteNodeWithImageNamed:kOGTorchComponentLightImageName];
    light.name = kOGTorchComponentLightName;
    light.zPosition = 1;
    light.colorBlendFactor = 0.0;
    light.size = CGSizeMake(self.torchRadius, self.torchRadius);
    
    [self.torchSprite addChild:light];
}

- (void)createDarknessWithSize:(CGSize)size
{
    CGFloat diagonal = powf(powf(size.height, 2.0) + powf(size.width, 2.0), 0.5) + self.torchRadius;
    
    SKShapeNode *darkness = [SKShapeNode shapeNodeWithEllipseOfSize:CGSizeMake(diagonal, diagonal)];
    darkness.strokeColor = [SKColor gameBlack];
    darkness.zPosition = 1;
    darkness.lineWidth = diagonal - self.torchRadius;
    
    [self.torchSprite addChild:darkness];
}

- (void)dealloc
{
    [_torchSprite release];
    
    [super dealloc];
}

@end
