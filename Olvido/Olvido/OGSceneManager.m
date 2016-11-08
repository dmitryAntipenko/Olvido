//
//  OGSceneManager.m
//  Olvido
//
//  Created by Алексей Подолян on 11/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGSceneManager.h"
#import "OGBaseScene.h"
#import "OGSceneLoader.h"

@interface OGSceneManager ()

@property (nonatomic, strong) OGBaseScene *currentScene;
@property (nonatomic, strong) NSArray<OGSceneLoader *> *sceneLoaders;

@end

@implementation OGSceneManager

+ (instancetype)initWithView:(SKView *)view
{
    self = [self init];
    
    if (self)
    {
        _view = view;
    }
    
    return self;
}

- (instancetype)sceneManagerWithView:(SKView *)view
{
    return [[OGSceneManager alloc] initWithView:view];
}

- (void)prepareSceneWithIdentifier:(NSString *)sceneIdentifier
{
    
}

- (void)transitionToSceneWithIdentifier:(NSString *)sceneIdentifier
{
    
}

@end
