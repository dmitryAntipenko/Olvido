//
//  OGScenesController.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGScenesController.h"
#import "OGGameSceneDelegate.h"
#import "OGGameScene+OGGameSceneCreation.h"
#import "SKColor+OGConstantColors.h"

#import "OGEntity.h"
#import "OGSpriteNode.h"
#import "OGTransitionComponent.h"
#import "OGVisualComponent.h"

#import "OGGameOverState.h"
#import "OGPauseState.h"
#import "OGMainMenuState.h"
#import "OGGameState.h"

NSString *const kOGSceneControllerLevelMapName = @"LevelsMap";
NSString *const kOGSceneControllerLevelMapExtension = @"plist";

NSString *const kOGSceneControllerPortalsKey = @"Portals";
NSString *const kOGSceneControllerNextLevelIndexKey = @"Next Level Index";
NSString *const kOGSceneControllerLocationKey = @"Location";
NSString *const kOGSceneControllerClassNameKey = @"Class Name";
NSString *const kOGSceneControllerPortalColorKey = @"Color";
NSString *const kOGSceneControllerEnemiesCountKey = @"Enemies Count";

NSUInteger const kOGSceneControllerInitialLevelIndex = 0;

CGFloat const kOGSceneControllerTransitionDuration = 1.0;

@interface OGScenesController () <OGGameSceneDelegate>

@property (nonatomic, copy) NSArray *levelMap;

@end

@implementation OGScenesController

- (void)loadLevelMap    
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:kOGSceneControllerLevelMapName
                                                          ofType:kOGSceneControllerLevelMapExtension];
    NSArray *plistData = [NSArray arrayWithContentsOfFile:plistPath];
    
    self.levelMap = plistData;
}

- (void)loadInitialLevel
{
    [self loadLevelWithIdentifier:@(kOGSceneControllerInitialLevelIndex)];
    [self didLoadNextLevel];
    [self.view presentScene:self.currentScene];
}

- (NSNumber *)nextLevelIdentifierWithPortalLocation:(OGPortalLocation)location inLevel:(NSNumber *)identifier
{
    NSDictionary *level = self.levelMap[identifier.integerValue];
    NSArray *portals = level[kOGSceneControllerPortalsKey];
    NSNumber *result = 0;
    
    for (NSDictionary *portalDictionary in portals)
    {
        if ([portalDictionary[kOGSceneControllerLocationKey] integerValue] == location)
        {
            result = portalDictionary[kOGSceneControllerNextLevelIndexKey];
            break;
        }
    }
    
    return result;
}

- (void)gameSceneDidCallFinishWithPortal:(OGEntity *)portal
{
    OGTransitionComponent *transitionComponent = (OGTransitionComponent *) [portal componentForClass:[OGTransitionComponent class]];
    
    if (!transitionComponent.isClosed)
    {
        SKTransitionDirection nextSceneTransitionDirection = [self transitionDirectionWithPortalLocation:transitionComponent.location];
        
        NSNumber *nextLevelId = [self nextLevelIdentifierWithPortalLocation:transitionComponent.location
                                                                    inLevel:self.currentScene.identifier];
        [self loadLevelWithIdentifier:nextLevelId];
        
        self.currentScene.exitPortalLocation = transitionComponent.location;
        [self didLoadNextLevel];
        
        SKTransition *transition = [SKTransition pushWithDirection:nextSceneTransitionDirection
                                                            duration:kOGSceneControllerTransitionDuration];

        [self.view presentScene:self.currentScene transition:transition];
    }
}

- (void)didLoadNextLevel
{
    [self.currentScene createSceneContents];
}

- (void)loadLevelWithIdentifier:(NSNumber *)identifier
{
    NSString *className = self.levelMap[identifier.integerValue][kOGSceneControllerClassNameKey];
    NSArray *portals = self.levelMap[identifier.integerValue][kOGSceneControllerPortalsKey];
    
    self.currentScene.sceneDelegate = nil;
    
    Class class = NSClassFromString(className);
    OGGameScene *scene = [[class alloc] initWithSize:self.view.frame.size];
    
    scene.identifier = identifier;
    
    /* temorary code */
    scene.controlType = self.controlType;
    scene.godMode = self.godMode;
    /* temorary code */
    
    scene.enemiesCount = self.levelMap[identifier.integerValue][kOGSceneControllerEnemiesCountKey];
    scene.sceneDelegate = self;

    for (NSDictionary *portalDictionary in portals)
    {
        OGEntity *portal = [OGEntity entity];
        
        OGPortalLocation location = [portalDictionary[kOGSceneControllerLocationKey] integerValue];
        OGTransitionComponent *portalTransitionComponent = [[OGTransitionComponent alloc] initWithLocation:location];
        
        OGVisualComponent *portalVisualComponent = [[OGVisualComponent alloc] init];
        
        if (portalTransitionComponent.location == kOGPortalLocationUp
            || portalTransitionComponent.location == kOGPortalLocationDown)
        {
            portalVisualComponent.spriteNode = [OGSpriteNode spriteNodeWithImageNamed:kOGHorizontalPortalTextureName];
        }
        else if (portalTransitionComponent.location == kOGPortalLocationLeft
                 || portalTransitionComponent.location == kOGPortalLocationRight)
        {
            portalVisualComponent.spriteNode = [OGSpriteNode spriteNodeWithImageNamed:kOGVerticalPortalTextureName];
        }
        
        NSString *portalColor = portalDictionary[kOGSceneControllerPortalColorKey];
        
        portalVisualComponent.color = [SKColor colorWithString:portalColor];
        portalVisualComponent.spriteNode.owner = portalVisualComponent;
        portalVisualComponent.spriteNode.zPosition = 2.0;
        
        [portal addComponent:portalVisualComponent];
        [portal addComponent:portalTransitionComponent];
        
        [scene addPortalToScene:portal];
        
        [portalTransitionComponent release];
        [portalVisualComponent release];
    }
    
    self.currentScene = scene;
    [scene release];
}

- (SKTransitionDirection)transitionDirectionWithPortalLocation:(OGPortalLocation)location
{
    SKTransitionDirection result;
    
    switch (location)
    {
        case kOGPortalLocationDown:
            result = SKTransitionDirectionDown;
            break;
            
        case kOGPortalLocationUp:
            result = SKTransitionDirectionUp;
            break;
            
        case kOGPortalLocationRight:
            result = SKTransitionDirectionLeft;
            break;
            
        case kOGPortalLocationLeft:
            result = SKTransitionDirectionRight;
            break;
            
        default:
            result = SKTransitionDirectionDown;
            break;
    }
    
    return result;
}

- (void)gameSceneDidCallFinishGameWithScore:(NSNumber *)score
{
    if ([self.uiStateMachine canEnterState:[OGGameOverState class]])
    {
        ((OGGameOverState *) [self.uiStateMachine stateForClass:[OGGameOverState class]]).score = score;
        [self.uiStateMachine enterState:[OGGameOverState class]];
    }
}

- (void)gameSceneDidCallPause
{
    if ([self.uiStateMachine canEnterState:[OGPauseState class]])
    {
        [self.uiStateMachine enterState:[OGPauseState class]];
    }
}

- (void)gameSceneDidCallResume
{
//    [self.currentScene.pauseBarSprite removeAllChildren];
    [self.currentScene.pauseBarSprite removeFromParent];
    
    [self.uiStateMachine enterState:[OGGameState class]];
//    [((OGPauseState *)[self.uiStateMachine stateForClass:[OGPauseState class]]) resumeScene];
    
    [self.currentScene changeStatusBarLocationWithY:kOGGameSceneStatusBarYOffset * 2.0];
}

- (void)gameSceneDidCallMenu
{

    [self.uiStateMachine enterState:[OGMainMenuState class]];
}

- (void)gameSceneDidCallRestart
{
    [((OGMainMenuState *) [self.uiStateMachine stateForClass:[OGMainMenuState class]]) startGameWithControlType:self.controlType
                                                                                                            godMode:self.godMode];
}

- (void)dealloc
{
    [_levelMap release];
    [_currentScene release];
    [_uiStateMachine release];
    
    [super dealloc];
}

@end
