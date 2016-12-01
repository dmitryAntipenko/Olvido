//
//  OGLevelManager.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLevelManager.h"
#import "OGGameScene.h"
#import "OGStoryScene.h"
#import "OGConstants.h"
#import "OGSceneManager.h"
#import "OGMenuManager.h"

#import "OGPauseLevelState.h"
#import "OGGameLevelState.h"

NSString *const OGLevelManagerGameSceneIdentifierKey = @"GameSceneIdentifier";
NSString *const OGLevelManagerStorySceneIdentifierKey = @"StorySceneIdentifier";
NSString *const OGLevelManagerLevelMapName = @"LevelsMap";

@interface OGLevelManager () <OGGameSceneStoryDelegate>

@property (nonatomic, copy, readwrite) NSArray<NSDictionary *> *levelMap;
@property (nonatomic, copy, readwrite) NSString *currentSceneName;

@property (nonatomic, strong) NSNumber *currentStorySceneIdentifier;
@property (nonatomic, strong) NSNumber *currentGameSceneIdentifier;

@property (nonatomic, strong) OGGameScene *currentGameScene;
@property (nonatomic, strong) OGStoryScene *currentStoryScene;

@end

@implementation OGLevelManager

+ (instancetype)levelManager;
{
    OGLevelManager *levelManager = [[OGLevelManager alloc] init];
    [levelManager loadLevelMap];
    
    return levelManager;
}

- (void)loadLevelMap
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:OGLevelManagerLevelMapName
                                                          ofType:OGPropertyFileExtension];
    
    self.levelMap = [NSArray arrayWithContentsOfFile:plistPath];
}

#pragma mark - GameSceneDelegate methods

- (void)didCallFinish
{
    [self loadLevelWithIdentifier:@1];//will change to "Next level"
}

- (void)didCallPause
{
    if (self.currentGameScene)
    {
        if ([self.currentGameScene.stateMachine canEnterState:[OGPauseLevelState class]])
        {
            [self.currentGameScene.stateMachine enterState:[OGPauseLevelState class]];
        }
    }
}

- (void)didCallResume
{
    if (self.currentGameScene)
    {
        [self.currentGameScene.stateMachine enterState:[OGGameLevelState class]];
    }
}

- (void)didCallRestart
{
    [self clearCurrentScene];
    [self runGameScene];
}

- (void)didCallExit
{
    [self clearCurrentScene];
    [self.menuManager loadMenuWithName:OGMapMenuName];
}

- (void)clearCurrentScene
{
    if (self.currentGameScene)
    {
        self.currentGameScene.sceneDelegate = nil;
    }
    
    self.currentStoryScene = nil;
    
    if (self.currentStoryScene)
    {
        self.currentStoryScene.sceneDelegate = nil;
    }
    
    [self.audioManager stopMusic];
    self.currentGameScene = nil;
}

#pragma mark - GameSceneStoreDelegate method

- (void)storySceneDidCallFinish
{
    [self runGameScene];
}

#pragma mark - Loading and Running levels

- (void)runGameScene
{
    if (self.currentGameSceneIdentifier)
    {
        __weak typeof(self) weakSelf = self;
        
        [self.sceneManager transitionToSceneWithIdentifier:self.currentGameSceneIdentifier.integerValue
                                         completionHandler:^(OGBaseScene *scene)
         {
             if (weakSelf)
             {
                 typeof(weakSelf) strongSelf = weakSelf;
                 
                 strongSelf.currentGameScene = (OGGameScene *)scene;
                 strongSelf.currentGameScene.audioManager = self.audioManager;
                 strongSelf.currentGameScene.sceneDelegate = self;
             }
         }];
    }
}

- (void)runStoryScene
{
    if (self.currentStorySceneIdentifier)
    {
        [self.sceneManager transitionToSceneWithIdentifier:self.currentStorySceneIdentifier.integerValue
                                         completionHandler:^(OGBaseScene *scene)
         {
             self.currentStoryScene = (OGStoryScene *)scene;
             self.currentStoryScene.sceneDelegate = self;
         }];
        
        [self.sceneManager prepareSceneWithIdentifier:self.currentGameSceneIdentifier.integerValue];
    }
    else
    {
        [self runGameScene];
    }
}

- (void)loadLevelWithIdentifier:(NSNumber *)identifier
{
    [self clearCurrentScene];
    
    [self loadSceneIdentifiersWithLevelIdentifier:identifier];
    [self runStoryScene];
}

- (void)loadSceneIdentifiersWithLevelIdentifier:(NSNumber *)identifier;
{
    [self clearCurrentScene];
    
    self.currentGameSceneIdentifier = self.levelMap[identifier.integerValue][OGLevelManagerGameSceneIdentifierKey];
    self.currentStorySceneIdentifier = self.levelMap[identifier.integerValue][OGLevelManagerStorySceneIdentifierKey];
}

@end
