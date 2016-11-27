//
//  OGPlayerEntity+OGPlayerEntityResources.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/13/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerEntity+OGPlayerEntityResources.h"
#import "OGAnimationComponent.h"
#import "OGColliderType.h"

NSString *const OGPlayerEntityAtlasNamesPlayerBotIdle = @"PlayerBotIdle";
NSString *const OGPlayerEntityAtlasNamesPlayerBotWalk = @"PlayerBotWalk";

static NSDictionary<NSString *, NSDictionary *> *sOGPlayerEntityAnimations;
static NSDictionary<NSString *, SKTexture *> *sOGPlayerEntityAppearTextures;

@implementation OGPlayerEntity (OGPlayerEntityResources)

+ (BOOL)resourcesNeedLoading
{
    return sOGPlayerEntityAnimations == nil || sOGPlayerEntityAppearTextures == nil;
}

+ (void)loadResourcesWithCompletionHandler:(void (^)(void))completionHandler
{
    [OGPlayerEntity loadMiscellaneousAssets];
    
    NSArray *playerAtlasNames = @[OGPlayerEntityAtlasNamesPlayerBotIdle,
                                  OGPlayerEntityAtlasNamesPlayerBotWalk];
    
    [SKTextureAtlas preloadTextureAtlasesNamed:playerAtlasNames withCompletionHandler:^(NSError *error, NSArray<SKTextureAtlas *> *foundAtlases)
     {
         NSMutableDictionary *appearTextures = [NSMutableDictionary dictionary];
         
         for (NSUInteger i = 0; i < OGDirectionCount; i++)
         {
             appearTextures[OGDirectionDescription[i]] = [OGAnimationComponent firstTextureForOrientationWithDirection:i
                                                                                                                  atlas:foundAtlases[0]
                                                                                                        imageIdentifier:OGPlayerEntityAtlasNamesPlayerBotIdle];
         }
         
         sOGPlayerEntityAppearTextures = appearTextures;
         
         NSMutableDictionary *animations = [NSMutableDictionary dictionary];
         
         animations[OGAnimationStateDescription[OGAnimationStateIdle]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[0]
                                                                                                     imageIdentifier:OGPlayerEntityAtlasNamesPlayerBotIdle
                                                                                                      animationState:OGAnimationStateIdle
                                                                                                      bodyActionName:nil
                                                                                               repeatTexturesForever:YES
                                                                                                       playBackwards:NO
                                                                                                        timePerFrame:0.1];
         
         animations[OGAnimationStateDescription[OGAnimationStateWalkForward]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[1]
                                                                                                            imageIdentifier:OGPlayerEntityAtlasNamesPlayerBotWalk
                                                                                                             animationState:OGAnimationStateWalkForward
                                                                                                             bodyActionName:nil
                                                                                                      repeatTexturesForever:YES
                                                                                                              playBackwards:NO
                                                                                                               timePerFrame:0.1];
         
         sOGPlayerEntityAnimations = animations;
         
         completionHandler();
     }];
}

+ (CGSize)textureSize
{
    return CGSizeMake(120.0, 120.0);
}

+ (void)purgeResources
{
    sOGPlayerEntityAppearTextures = nil;
    sOGPlayerEntityAnimations = nil;
}

+ (NSDictionary *)sOGPlayerEntityAnimations
{
    return sOGPlayerEntityAnimations;
}

+ (NSDictionary *)sOGPlayerEntityAppearTextures
{
    return sOGPlayerEntityAppearTextures;
}

+ (void)loadMiscellaneousAssets
{
    NSArray *collisionColliders = @[[OGColliderType obstacle], [OGColliderType door], [OGColliderType enemy]];
    [[OGColliderType definedCollisions] setObject:collisionColliders forKey:[OGColliderType player]];
    
    NSArray *contactColliders = @[[OGColliderType weapon], [OGColliderType key]];
    [[OGColliderType requestedContactNotifications] setObject:contactColliders forKey:[OGColliderType player]];
}

@end
