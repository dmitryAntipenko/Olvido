//
//  OGButtonNode.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGButtonNode.h"
#import "OGConstants.h"

NSString *const kOGButtonNodeUserDataTouchedTextureKey = @"touchedTexture";

@interface OGButtonNode ()

@property (nonatomic, retain) SKTexture *touchedTexture;
@property (nonatomic, assign) SKTexture *defaultTexture;

@end

@implementation OGButtonNode

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.defaultTexture)
    {
        self.defaultTexture = self.texture;
    }
    
    if (!self.touchedTexture)
    {
        self.touchedTexture = [SKTexture textureWithImageNamed:[self.userData objectForKey:kOGButtonNodeUserDataTouchedTextureKey]];
    }
    
    self.texture = self.touchedTexture;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.texture = self.defaultTexture;
}

- (BOOL)isUserInteractionEnabled
{
    return YES;
}

@end
