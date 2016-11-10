//
//  OGLevelManager.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLevelManager.h"
#import "OGGameSceneDelegate.h"
#import "OGGameSceneStoryDelegate.h"
#import "OGGameScene.h"
#import "OGStoryScene.h"
#import "OGConstants.h"
#import "OGsceneManager.h"

NSUInteger const kOGLevelManagerInitialLevelIndex = 0;

NSString *const kOGLevelManagerLevelMapName = @"LevelsMap";

NSString *const kOGSceneControllerPortalsKey = @"Portals";
NSString *const kOGSceneControllerNextLevelIndexKey = @"Next Level Index";
NSString *const kOGSceneControllerPortalIdentifierKey = @"Identifier";
NSString *const kOGSceneControllerClassNameKey = @"Class Name";
NSString *const kOGSceneControllerPortalColorKey = @"Color";
NSString *const kOGSceneControllerEnemiesCountKey = @"Enemies Count";

NSString *const kOGSceneControllerStorySceneName = @"Story Scene Name";

CGFloat const kOGSceneControllerTransitionDuration = 1.0;

/* temporary code */
NSString *const kOGLevelManagerDragControl = @"drag";
NSString *const kOGLevelManagerTapContinueControl = @"tapContinue";
NSString *const kOGLevelManagerTapStopControl = @"tapStop";
/* temporary code */

@interface OGLevelManager () <OGGameSceneDelegate, OGGameSceneStoryDelegate>

@property (nonatomic, copy, readwrite) NSArray<NSDictionary *> *levelMap;
@property (nonatomic, copy, readwrite) NSString *currentSceneName;
@property (nonatomic, strong, readwrite) OGGameScene *currentGameScene;
@property (nonatomic, strong, readwrite) OGStoryScene *currentStoryScene;

@end

@implementation OGLevelManager

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _controlType = kOGLevelManagerTapStopControl;
    }
    
    return self;
}

+ (OGLevelManager *)sharedInstance
{
    static OGLevelManager *levelManager = nil;
    static dispatch_once_t dispatchOnceToken = 0;
    
    dispatch_once(&dispatchOnceToken, ^()
                  {
                      levelManager = [[OGLevelManager alloc] init];
                      [levelManager loadLevelMap];
                  });
    
    return levelManager;
}

- (void)loadLevelMap
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:kOGLevelManagerLevelMapName
                                                          ofType:kOGPropertyFileExtension];
    
    NSArray *plistData = [NSArray arrayWithContentsOfFile:plistPath];
    
    self.levelMap = plistData;
}

- (NSNumber *)nextLevelIdentifierWithPortalIdentifier:(NSNumber *)identifier inLevel:(NSNumber *)levelIdentifier
{
    NSDictionary *level = self.levelMap[levelIdentifier.integerValue];
    NSArray *portals = level[kOGSceneControllerPortalsKey];
    NSNumber *result = 0;
    
    for (NSDictionary *portalDictionary in portals)
    {
        if ([portalDictionary[kOGSceneControllerPortalIdentifierKey] integerValue] == identifier.integerValue)
        {
            result = portalDictionary[kOGSceneControllerNextLevelIndexKey];
            break;
        }
    }
    
    return result;
}

#pragma mark - GameSceneDelegate methods

//- (void)gameSceneDidCallFinish
//{
//    NSNumber *portalIdentifier = @(self.currentGameScene.transitionComponent.identifier);
//    NSNumber *nextLevelId = [self nextLevelIdentifierWithPortalIdentifier:portalIdentifier
//                                                                  inLevel:self.currentGameScene.identifier];
//
//    [self loadLevelWithIdentifier:nextLevelId];
//
//    if (self.currentGameScene)
//    {
//        SKTransition *transition = [SKTransition doorwayWithDuration:kOGSceneControllerTransitionDuration];
//        [self.view presentScene:self.currentGameScene transition:transition];
//    }
//}

- (void)gameSceneDidCallRestart
{
    [self loadLevelWithIdentifier:self.currentGameScene.identifier];
    [self runGameScene];
}

#pragma mark - GameSceneStoreDelegate method

- (void)gameSceneDidFinishRunStory
{
    [self runGameScene];
}

#pragma mark - Loading and Running levels

- (void)runGameScene
{
    if (self.currentGameScene)
    {
        [self.view presentScene:self.currentGameScene];
    }
}

- (void)runStoryScene
{
    if (self.currentStoryScene)
    {
        [self.view presentScene:self.currentStoryScene];
    }
    else
    {
        [self runGameScene];
    }
}

- (void)loadLevelWithIdentifier:(NSNumber *)identifier
{
//        NSString *className = self.levelMap[identifier.integerValue][kOGSceneControllerClassNameKey];
    NSUInteger sceneIdentifier = [self.levelMap[identifier.integerValue][@"SceneIdentifier"] integerValue];
    [self.sceneManager transitionToSceneWithIdentifier:sceneIdentifier];
//    GKScene *sceneFile = [GKScene sceneWithFileNamed:className];
//    OGGameScene *scene = (OGGameScene *)sceneFile.rootNode;
//
//    scene.identifier = identifier;
//    scene.sceneDelegate = self;
//    
//    //    for (GKEntity *entity in sceneFile.entities)
//    //    {
//    //        GKSKNodeComponent *nodeComponent = (GKSKNodeComponent *) [entity componentForClass:[GKSKNodeComponent class]];
//    //
//    //        OGSpriteNode *spriteNode = (OGSpriteNode *) nodeComponent.node;
//    //        spriteNode.entity = (GKEntity *) nodeComponent.entity;
//    //
//    ////        [scene addSpriteNode:spriteNode];
//    //    }
//    
//    scene.scaleMode = SKSceneScaleModeAspectFit;
//    self.currentGameScene = scene;
//    self.currentSceneName = className;
//    
//    NSString *storySceneName = self.levelMap[identifier.integerValue][kOGSceneControllerStorySceneName];
//    GKScene *storySceneFile = [GKScene sceneWithFileNamed:storySceneName];
//    OGStoryScene *storyScene = (OGStoryScene *)storySceneFile.rootNode;
//    
//    storyScene.sceneDelegate = self;
//    storyScene.scaleMode = SKSceneScaleModeAspectFit;
//    
//    self.currentStoryScene = storyScene;
}


@end
