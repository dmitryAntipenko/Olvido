//
//  OGLoadingScene.m
//  Olvido
//
//  Created by Алексей Подолян on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLoadingScene.h"

CGFloat const kOGLoadingSceneLoadingBarOptimalScaleFactor = 0.2;
CGFloat const kOGLoadingSceneLoadingBarRotatingActionTimeInterval = 0.2;

@implementation OGLoadingScene

- (void)didMoveToView:(SKView *)view
{
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor]
                                                            size:self.view.bounds.size];
    
    CGSize loadingBarSize = [self calculateLoadingBarSize];
    SKSpriteNode *loadingBarNode = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor]
                                                                size:loadingBarSize];
    
    [loadingBarNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI
                                                                            duration:kOGLoadingSceneLoadingBarRotatingActionTimeInterval]]];
    
    [self addChild:background];
    [self addChild:loadingBarNode];
}

- (CGSize)calculateLoadingBarSize
{
    CGSize result = CGSizeZero;
    
    if (self.view)
    {
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = self.view.bounds.size.height;
        
        CGFloat loadingBarLength = 0;
        
        if (height < width)
        {
            loadingBarLength = height * kOGLoadingSceneLoadingBarOptimalScaleFactor;
        }
        else
        {
            loadingBarLength = width * kOGLoadingSceneLoadingBarOptimalScaleFactor;
        }
        
        result = CGSizeMake(loadingBarLength, loadingBarLength);
    }
    
    return result;
}

@end
