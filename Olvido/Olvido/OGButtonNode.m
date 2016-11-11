//
//  OGButtonNode.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGButtonNode.h"
#import "OGConstants.h"
#import "SKColor+OGConstantColors.h"

NSString *const kOGButtonNodeUserDataTouchedBlendFactorKey = @"touchedBlendFactor";
NSString *const kOGButtonNodeUserDataTouchedAlphaKey = @"touchedAlpha";
NSString *const kOGButtonNodeUserDataTouchedTextureKey = @"touchedTexture";
NSString *const kOGButtonNodeUserDataTouchedColorKey = @"touchedColor";
NSString *const kOGButtonNodeUserDataSelectorKey = @"selector";
NSString *const kOGButtonNodeDefaultSelectorName =  @"onButtonClick:";

@interface OGButtonNode ()

@property (nonatomic, strong) SKTexture *touchedTexture;
@property (nonatomic, strong) SKTexture *preTouchedTexture;
@property (nonatomic, unsafe_unretained) CGFloat preTouchedAlpha;
@property (nonatomic, unsafe_unretained) CGFloat preTouchedBlendFactor;

@property (nonatomic, strong) SKColor *touchedColor;
@property (nonatomic, strong) SKColor *preTouchedColor;
@property (nonatomic, unsafe_unretained) CGFloat touchedAlpha;
@property (nonatomic, unsafe_unretained) CGFloat touchedBlendFactor;

@end
@implementation OGButtonNode

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.preTouchedTexture = self.texture;
    self.preTouchedColor = self.color;
    self.preTouchedAlpha = self.alpha;
    self.preTouchedBlendFactor = self.colorBlendFactor;
    
    self.texture = self.touchedTexture;
    self.color = self.touchedColor;
    self.alpha = self.touchedAlpha;
    self.colorBlendFactor = self.touchedBlendFactor;
}

- (SKTexture *)touchedTexture
{
    if (!_touchedTexture)
    {
        NSString *touchedTextureName = [self.userData objectForKey:kOGButtonNodeUserDataTouchedTextureKey];
        
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
        NSString *touchedColorHexString = [self.userData objectForKey:kOGButtonNodeUserDataTouchedColorKey];
        
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

- (CGFloat)touchedAlpha
{
    static BOOL initialized = NO;
    
    if (!initialized)
    {
        NSString *touchedAlphaString = [self.userData objectForKey:kOGButtonNodeUserDataTouchedAlphaKey];
        
        if (touchedAlphaString)
        {
            _touchedAlpha = [touchedAlphaString doubleValue];
        }
        else
        {
            _touchedAlpha = self.alpha;
        }
        
        initialized = YES;
    }
    
    return _touchedAlpha;
}

- (CGFloat)touchedBlendFactor
{
    static BOOL initialized = NO;
    
    if (!initialized)
    {
        NSString *touchedBlendFactor = [self.userData objectForKey:kOGButtonNodeUserDataTouchedBlendFactorKey];
        
        if (touchedBlendFactor)
        {
            _touchedBlendFactor = [touchedBlendFactor doubleValue];
        }
        else
        {
            _touchedBlendFactor = self.colorBlendFactor;
        }
        
        initialized = YES;
    }
    
    return _touchedBlendFactor;
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
    NSString *selectorName = [self.userData objectForKey:kOGButtonNodeUserDataSelectorKey];
    
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
        SEL defaultSelector = NSSelectorFromString(kOGButtonNodeDefaultSelectorName);
        
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
