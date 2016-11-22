//
//  OGEnemyEntity+OGEnemyEntityResources.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyEntity+OGEnemyEntityResources.h"
#import "OGAnimationComponent.h"
#import "OGColliderType.h"

NSString *const kOGEnemyEntityAtlasNamesEnemyIdle = @"EnemyIdle";
NSString *const kOGEnemyEntityAtlasNamesEnemyWalk = @"EnemyWalk";
NSString *const kOGEnemyEntityAtlasNamesEnemyRun = @"EnemyRun";
NSString *const kOGEnemyEntityAtlasNamesEnemyAttack = @"EnemyAttack";
NSString *const kOGEnemyEntityAtlasNamesEnemyDead = @"EnemyDead";

static NSDictionary<NSString *, NSDictionary *> *sOGEnemyEntityAnimations;

@implementation OGEnemyEntity (OGEnemyEntityResources)

+ (BOOL)resourcesNeedLoading
{
    return sOGEnemyEntityAnimations == nil;
}

+ (void)loadResourcesWithCompletionHandler:(void (^)())completionHandler
{
    [OGEnemyEntity loadMiscellaneousAssets];
    
    NSArray *enemyAtlasNames = @[kOGEnemyEntityAtlasNamesEnemyIdle,
                                 kOGEnemyEntityAtlasNamesEnemyWalk,
                                 kOGEnemyEntityAtlasNamesEnemyRun,
                                 kOGEnemyEntityAtlasNamesEnemyAttack,
                                 kOGEnemyEntityAtlasNamesEnemyDead];
    
    [SKTextureAtlas preloadTextureAtlasesNamed:enemyAtlasNames withCompletionHandler:^(NSError *error, NSArray<SKTextureAtlas *> *foundAtlases)
     {
         NSMutableDictionary *animations = [NSMutableDictionary dictionary];
         
         animations[kOGAnimationStateDescription[kOGAnimationStateIdle]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[0]
                                                                                                     imageIdentifier:kOGEnemyEntityAtlasNamesEnemyIdle
                                                                                                      animationState:kOGAnimationStateIdle
                                                                                                      bodyActionName:nil
                                                                                               repeatTexturesForever:YES
                                                                                                       playBackwards:NO];
         
         animations[kOGAnimationStateDescription[kOGAnimationStateWalkForward]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[1]
                                                                                                            imageIdentifier:kOGEnemyEntityAtlasNamesEnemyWalk
                                                                                                             animationState:kOGAnimationStateWalkForward
                                                                                                             bodyActionName:nil
                                                                                                      repeatTexturesForever:YES
                                                                                                              playBackwards:NO];
         
         animations[kOGAnimationStateDescription[kOGAnimationStateRun]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[2]
                                                                                                    imageIdentifier:kOGEnemyEntityAtlasNamesEnemyRun
                                                                                                     animationState:kOGAnimationStateRun
                                                                                                     bodyActionName:nil
                                                                                              repeatTexturesForever:YES
                                                                                                      playBackwards:NO];
         
         animations[kOGAnimationStateDescription[kOGAnimationStateAttack]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[3]
                                                                                                       imageIdentifier:kOGEnemyEntityAtlasNamesEnemyAttack
                                                                                                        animationState:kOGAnimationStateAttack
                                                                                                        bodyActionName:nil
                                                                                                 repeatTexturesForever:NO
                                                                                                         playBackwards:NO];
         
         animations[kOGAnimationStateDescription[kOGAnimationStateDead]] = [OGAnimationComponent animationsWithAtlas:foundAtlases[4]
                                                                                                     imageIdentifier:kOGEnemyEntityAtlasNamesEnemyDead
                                                                                                      animationState:kOGAnimationStateDead
                                                                                                      bodyActionName:nil
                                                                                               repeatTexturesForever:NO
                                                                                                       playBackwards:NO];
         
         sOGEnemyEntityAnimations = animations;
         
         completionHandler();
     }];
}

+ (void)purgeResources
{
    sOGEnemyEntityAnimations = nil;
}

+ (void)loadMiscellaneousAssets
{
    NSArray *collisionColliders = [NSArray arrayWithObjects:[OGColliderType obstacle], [OGColliderType door], nil];
    [[OGColliderType definedCollisions] setObject:collisionColliders forKey:[OGColliderType enemy]];
    
    NSArray *contactColliders = [NSArray arrayWithObject:[OGColliderType player]];
    [[OGColliderType requestedContactNotifications] setObject:contactColliders forKey:[OGColliderType enemy]];
}

+ (NSDictionary *)sOGEnemyEntityAnimations
{
    return sOGEnemyEntityAnimations;
}

@end
