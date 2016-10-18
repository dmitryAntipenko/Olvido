//
//  OGTorchComponent.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/18/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTorchComponent.h"

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
        if (![self.torchSprite childNodeWithName:kOGTorchComponentLightName])
        {
            [self createLight];
        }
        
        
    }
}

- (void)tourchTornOff
{
    
}

- (void)createLight
{
    SKSpriteNode *light = [SKSpriteNode spriteNodeWithImageNamed:kOGTorchComponentLightImageName];
    light.name = kOGTorchComponentLightName;
    light.zPosition = 1;
    light.size = CGSizeMake(self.torchRadius, self.torchRadius);
    
    [self.torchSprite addChild:light];
}

- (void)dealloc
{
    [_torchSprite release];
    
    [super dealloc];
}

@end
