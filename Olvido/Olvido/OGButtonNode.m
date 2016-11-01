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
NSString *const kOGButtonNodeUserDataNextSceneKey = @"nextScene";
NSString *const kOGButtonNodeUserDataSelectorKey = @"selector";

@interface OGButtonNode ()

@property (nonatomic, strong) SKTexture *touchedTexture;
@property (nonatomic, strong) SKTexture *preTouchedTexture;

@end

@implementation OGButtonNode

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.preTouchedTexture)
    {
        self.preTouchedTexture = self.texture;
    }
    
    if (!self.touchedTexture)
    {
        self.touchedTexture = [SKTexture textureWithImageNamed:[self.userData objectForKey:kOGButtonNodeUserDataTouchedTextureKey]];
    }
    
    self.texture = self.touchedTexture;
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
    NSString *nextSceneName = [self.userData objectForKey:kOGButtonNodeUserDataNextSceneKey];
    
    if (nextSceneName)
    {
        NSString *nextSceneFilePath = [[NSBundle mainBundle] pathForResource:nextSceneName ofType:kOGSceneFileExtension];
        
        if (nextSceneFilePath)
        {
            SKScene *nextScene = [NSKeyedUnarchiver unarchiveObjectWithFile:nextSceneFilePath];
            
            [self.scene.view presentScene:nextScene];
        }
    }
    
    NSString *selectorName = [self.userData objectForKey:kOGButtonNodeUserDataSelectorKey];
    
    if (selectorName)
    {
        SEL selector = NSSelectorFromString(selectorName);
        
        if ([self.scene respondsToSelector:selector])
        {
            [self.scene performSelector:selector];
        }
    }
}

- (BOOL)isUserInteractionEnabled
{
    return YES;
}


@end
