//
//  OGLevelController.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLevelController.h"
#import "OGGameSceneDelegate.h"
#import "OGGameScene.h"
#import "OGSpriteNode.h"
#import "OGTransitionComponent.h"

NSUInteger const kOGSceneControllerInitialLevelIndex = 0;

NSString *const kOGSceneControllerLevelMapName = @"LevelsMap";
NSString *const kOGSceneControllerLevelMapExtension = @"plist";

NSString *const kOGSceneControllerPortalsKey = @"Portals";
NSString *const kOGSceneControllerNextLevelIndexKey = @"Next Level Index";
NSString *const kOGSceneControllerPortalIdentifierKey = @"Identifier";
NSString *const kOGSceneControllerClassNameKey = @"Class Name";
NSString *const kOGSceneControllerPortalColorKey = @"Color";
NSString *const kOGSceneControllerEnemiesCountKey = @"Enemies Count";

CGFloat const kOGSceneControllerTransitionDuration = 1.0;

/* temporary code */
NSString *const kOGLevelControllerDragControl = @"drag";
NSString *const kOGLevelControllerTapContinueControl = @"tapContinue";
NSString *const kOGLevelControllerTapStopControl = @"tapStop";
/* temporary code */

@interface OGLevelController () <OGGameSceneDelegate>

@property (nonatomic, copy, readwrite) NSArray *levelMap;
@property (nonatomic, retain, readwrite) OGGameScene *currentScene;

@end

@implementation OGLevelController

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _controlType = kOGLevelControllerTapStopControl;
    }
    
    return self;
}

+ (OGLevelController *)sharedInstance
{
    static OGLevelController *levelController = nil;
    static dispatch_once_t dispatchOnceToken = 0;
    
    dispatch_once(&dispatchOnceToken, ^()
    {
        levelController = [[OGLevelController alloc] init];
    });
    
    return levelController;
}

- (void)loadLevelMap
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:kOGSceneControllerLevelMapName
                                                          ofType:kOGSceneControllerLevelMapExtension];
    
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

- (void)gameSceneDidCallFinish
{
    NSNumber *portalIdentifier = @(self.currentScene.transitionComponent.identifier);
    NSNumber *nextLevelId = [self nextLevelIdentifierWithPortalIdentifier:portalIdentifier
                                                                  inLevel:self.currentScene.identifier];
    
    [self loadLevelWithIdentifier:nextLevelId];
    
    if (self.currentScene)
    {
        SKTransition *transition = [SKTransition doorwayWithDuration:kOGSceneControllerTransitionDuration];
        [self.view presentScene:self.currentScene transition:transition];
    }
}

- (void)gameSceneDidCallFinishGameWithScore:(NSNumber *)score
{
    
}

- (void)runScene
{
    [self.view presentScene:self.currentScene];
}

- (void)loadLevelWithIdentifier:(NSNumber *)identifier
{
    NSString *className = self.levelMap[identifier.integerValue][kOGSceneControllerClassNameKey];
    GKScene *sceneFile = [GKScene sceneWithFileNamed:className];
    OGGameScene *scene = (OGGameScene *)sceneFile.rootNode;
    
    scene.identifier = identifier;
    scene.sceneDelegate = self;
    
    for (GKEntity *entity in sceneFile.entities)
    {
        GKSKNodeComponent *nodeComponent = (GKSKNodeComponent *) [entity componentForClass:[GKSKNodeComponent class]];
        
        OGSpriteNode *spriteNode = (OGSpriteNode *) nodeComponent.node;
        spriteNode.entity = (OGEntity *) nodeComponent.entity;
        
        [scene addSpriteNode:spriteNode];
    }
    
    scene.scaleMode = SKSceneScaleModeAspectFit;
    self.currentScene = scene;
    [scene release];
}

- (void)dealloc
{
    [_levelMap release];
    [_currentScene release];
    [_controlType release];
    
    [super dealloc];
}

@end
