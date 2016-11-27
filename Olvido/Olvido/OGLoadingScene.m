//
//  OGLoadingScene.m
//  Olvido
//
//  Created by Алексей Подолян on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLoadingScene.h"
#import "OGSceneLoader.h"

CGFloat const OGLoadingSceneLoadingBarOptimalScaleFactor = 0.07;
CGFloat const OGLoadingSceneLoadingBarRotatingActionTimeInterval = 0.4;

@interface OGLoadingScene ()

@property (nonatomic, strong) OGSceneLoader *sceneLoader;

@end

@implementation OGLoadingScene

+ (instancetype)loadingSceneWithSceneLoader:(OGSceneLoader *)sceneLoader
{
    return [[OGLoadingScene alloc] initWithSceneLoader:sceneLoader];
}

- (instancetype)initWithSceneLoader:(OGSceneLoader *)sceneLoader
{
    if (sceneLoader)
    {
        self = [self init];
        
        if (self)
        {
            _sceneLoader = sceneLoader;
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    self.size = self.view.bounds.size;
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor]
                                                            size:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    
    background.position = CGPointMake(self.view.frame.size.width / 2.0,
                                      self.view.frame.size.height / 2.0);
    
    CGSize loadingBarSize = [self calculateLoadingBarSize];
    SKSpriteNode *loadingBarNode = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor]
                                                                size:loadingBarSize];
    
    [loadingBarNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI
                                                                            duration:OGLoadingSceneLoadingBarRotatingActionTimeInterval]]];
    
    [background addChild:loadingBarNode];
    [self addChild:background];
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
            loadingBarLength = height * OGLoadingSceneLoadingBarOptimalScaleFactor;
        }
        else
        {
            loadingBarLength = width * OGLoadingSceneLoadingBarOptimalScaleFactor;
        }
        
        result = CGSizeMake(loadingBarLength, loadingBarLength);
    }
    
    return result;
}

@end
