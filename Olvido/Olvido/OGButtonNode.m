//
//  OGButtonNode.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGButtonNode.h"
#import "SKColor+OGConstantColors.h"
#import "OGConstants.h"

NSString *const OGButtonNodeUserDataTouchedTextureKey = @"touchedTexture";
NSString *const OGButtonNodeUserDataTouchedColorKey = @"touchedColor";
NSString *const OGButtonNodeUserDataSelectorKey = @"selector";
NSString *const OGButtonNodeDefaultSelectorName =  @"onButtonClick:";

@interface OGButtonNode ()

@property (nonatomic, strong) SKTexture *touchedTexture;
@property (nonatomic, strong) SKTexture *preTouchedTexture;

@property (nonatomic, strong) SKColor *touchedColor;
@property (nonatomic, strong) SKColor *preTouchedColor;

@end
@implementation OGButtonNode

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.preTouchedTexture = self.texture;
    self.preTouchedColor = self.color;
    
    self.texture = self.touchedTexture;
    self.color = self.touchedColor;
}

- (SKTexture *)touchedTexture
{
    if (!_touchedTexture)
    {
        NSString *touchedTextureName = [self.userData objectForKey:OGButtonNodeUserDataTouchedTextureKey];
        
        if (touchedTextureName)
        {
            _touchedTexture = [SKTexture textureWithImageNamed:touchedTextureName];
        }
        else
        {
            _touchedTexture = self.texture;
        }
    }
    
    return _touchedTexture;
}

- (UIColor *)touchedColor
{
    if (!_touchedColor)
    {
        NSString *touchedColorHexString = [self.userData objectForKey:OGButtonNodeUserDataTouchedColorKey];
        
        if (touchedColorHexString)
        {
            _touchedColor = [SKColor colorWithString:touchedColorHexString];
        }
        else
        {
            _touchedColor = self.color;
        }
    }
    
    return _touchedColor;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.texture = self.preTouchedTexture;
    self.color = self.preTouchedColor;
    
    CGPoint touchlocation = [touches.anyObject locationInNode:self.parent];
    
    if ([self containsPoint:touchlocation])
    {
        [self doAction];
    }
}

- (void)doAction
{
    NSString *selectorName = [self.userData objectForKey:OGButtonNodeUserDataSelectorKey];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    if (selectorName)
    {
        SEL selector = NSSelectorFromString(selectorName);
        
        if ([self.scene respondsToSelector:selector])
        {
            [self.scene performSelector:selector];
        }
    }
    else
    {
        SEL defaultSelector = NSSelectorFromString(OGButtonNodeDefaultSelectorName);
        
        if ([self.scene respondsToSelector:defaultSelector])
        {
            [self.scene performSelector:defaultSelector withObject:self];
        }
    }
    
#pragma clang diagnostic pop
}

- (BOOL)isUserInteractionEnabled
{
    return YES;
}

@end
