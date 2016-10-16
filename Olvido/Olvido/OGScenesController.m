//
//  OGScenesController.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGScenesController.h"
#import "OGGameSceneDelegate.h"
#import "OGGameScene.h"
#import "SKColor+OGConstantColors.h"

#import "OGEntity.h"
#import "OGSpriteNode.h"
#import "OGTransitionComponent.h"
#import "OGVisualComponent.h"

NSString *const kOGSceneControllerLevelMapName = @"LevelsMap";
NSString *const kOGSceneControllerLevelMapExtension = @"plist";

NSString *const kOGSceneControllerPortalsKey = @"Portals";
NSString *const kOGSceneControllerNextLevelIndexKey = @"Next Level Index";
NSString *const kOGSceneControllerLocationKey = @"Location";
NSString *const kOGSceneControllerClassNameKey = @"Class Name";

NSUInteger const kOGSceneControllerInitialLevelIndex = 0;

CGFloat const kOGSceneControllerTransitionDuration = 1.0;

NSString *const kOGSceneControllerHorizontalPortalTextureName = @"PortalHorizontal";
NSString *const kOGSceneControllerVerticalPortalTextureName = @"PortalVertical";

@interface OGScenesController () <OGGameSceneDelegate>

@property (nonatomic, retain) OGGameScene *currentScene;
@property (nonatomic, copy) NSArray *levelMap;

@end

@implementation OGScenesController

- (instancetype)init
{
    self = [super init];
    
    if (!self)
    {
        [self release];
        self = nil;
    }
    
    return self;
}

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
    SKTransitionDirection nextSceneTransitionDirection = [self transitionDirectionWithPortalLocation:transitionComponent.location];
    
    NSNumber *nextLevelId = [self nextLevelIdentifierWithPortalLocation:transitionComponent.location
                                                                inLevel:self.currentScene.identifier];
    [self loadLevelWithIdentifier:nextLevelId];
    
    SKTransition *transition = [SKTransition moveInWithDirection:nextSceneTransitionDirection
                                                        duration:kOGSceneControllerTransitionDuration];

    [self.view presentScene:self.currentScene transition:transition];
}

- (void)loadLevelWithIdentifier:(NSNumber *)identifier
{
    NSString *className = self.levelMap[identifier.integerValue][kOGSceneControllerClassNameKey];
    NSArray *portals = self.levelMap[identifier.integerValue][kOGSceneControllerPortalsKey];
    
    Class class = NSClassFromString(className);
    OGGameScene *scene = [[class alloc] initWithSize:self.view.frame.size];
    
    scene.identifier = identifier;
    scene.sceneDelegate = self;
    [scene createSceneContents];

    for (NSDictionary *portalDictionary in portals)
    {
        OGEntity *portal = [OGEntity entity];
        
        OGPortalLocation location = [portalDictionary[kOGSceneControllerLocationKey] integerValue];
        OGTransitionComponent *portalTransitionComponent = [[OGTransitionComponent alloc] initWithLocation:location];
        
        OGVisualComponent *portalVisualComponent = [[OGVisualComponent alloc] init];
        
        if (portalTransitionComponent.location == kOGPortalLocationUp
            || portalTransitionComponent.location == kOGPortalLocationDown)
        {
            portalVisualComponent.spriteNode = [OGSpriteNode spriteNodeWithImageNamed:kOGSceneControllerHorizontalPortalTextureName];
        }
        else if (portalTransitionComponent.location == kOGPortalLocationLeft
                 || portalTransitionComponent.location == kOGPortalLocationRight)
        {
            portalVisualComponent.spriteNode = [OGSpriteNode spriteNodeWithImageNamed:kOGSceneControllerVerticalPortalTextureName];
        }
        
        portalVisualComponent.spriteNode.owner = portalVisualComponent;
        
        [portal addComponent:portalVisualComponent];
        [portal addComponent:portalTransitionComponent];
        
        [scene addPortal:portal];
        
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
            result = SKTransitionDirectionUp;
            break;
            
        case kOGPortalLocationUp:
            result = SKTransitionDirectionDown;
            break;
            
        case kOGPortalLocationRight:
            result = SKTransitionDirectionRight;
            break;
            
        case kOGPortalLocationLeft:
            result = SKTransitionDirectionLeft;
            break;
            
        default:
            result = SKTransitionDirectionDown;
            break;
    }
    
    return result;
}

- (void)dealloc
{
    [_levelMap release];
    [_currentScene release];
    
    [super dealloc];
}

@end
