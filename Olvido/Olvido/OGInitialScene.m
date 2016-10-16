//
//  OGInitialScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGInitialScene.h"
#import "OGPortal.h"
#import "SKColor+OGConstantColors.h"

@interface OGInitialScene ()

@end

@implementation OGInitialScene

- (void)createSceneContents
{
    self.backgroundColor = [SKColor backgroundLightGrayColor];
}

- (void)addPortal:(OGPortal *)portal
{
    if (portal.location == kOGPortalLocationUp || location == kOGPortalLocationDown)
    {
        portalTexture = [SKTexture textureWithImageNamed:kOGPortalHorizontalTextureName];
    }
    else if (location == kOGPortalLocationRight || location == kOGPortalLocationLeft)
    {
        portalTexture = [SKTexture textureWithImageNamed:kOGPortalVerticalTextureName];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.sceneDelegate gameSceneDidCallFinish];
}

- (void)dealloc
{
    [super dealloc];
}

@end
