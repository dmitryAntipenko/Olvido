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
NSString *const kOGButtonNodeUserDataSelectorKey = @"selector";

@interface OGButtonNode ()

@property (nonatomic, strong) SKTexture *touchedTexture;
@property (nonatomic, strong) SKTexture *preTouchedTexture;

@end

@implementation OGButtonNode

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.preTouchedTexture = self.texture;
    self.texture = self.touchedTexture;
}

- (SKTexture *)touchedTexture
{
    if (!_touchedTexture)
    {
        _touchedTexture = [SKTexture textureWithImageNamed:[self.userData objectForKey:kOGButtonNodeUserDataTouchedTextureKey]];
    }
    
    return _touchedTexture;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.texture = self.preTouchedTexture;
    
    CGPoint touchlocation = [touches.anyObject locationInNode:self.parent];
    
    if ([self containsPoint:touchlocation])
    {
        [self doAction];
    }
}

- (void)doAction
{
    NSString *selectorName = [self.userData objectForKey:kOGButtonNodeUserDataSelectorKey];
    
    if (selectorName)
    {
        SEL selector = NSSelectorFromString(selectorName);
        
        if ([self.scene respondsToSelector:selector])
        {
            [self.scene performSelector:selector withObject:self];
        }
    }
}

- (BOOL)isUserInteractionEnabled
{
    return YES;
}


@end
