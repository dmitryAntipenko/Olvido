//
//  OGPlayerEntity+OGPlayerEntityResources.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/13/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerEntity+OGPlayerEntityResources.h"
#import "OGColliderType.h"

static BOOL sResourcesNeedLoading = YES;

@implementation OGPlayerEntity (OGPlayerEntityResources)

+ (BOOL)resourcesNeedLoading
{
    return sResourcesNeedLoading;
}

+ (void)loadResourcesWithCompletionHandler:(void (^)(void))completionHandler
{
    [OGPlayerEntity loadMiscellaneousAssets];
    sResourcesNeedLoading = NO;
    
    completionHandler();
}

+ (void)purgeResources
{
    sResourcesNeedLoading = YES;
}

+ (void)loadMiscellaneousAssets
{
    NSArray *collisionColliders = @[[OGColliderType obstacle], [OGColliderType door], [OGColliderType enemy]];
    [[OGColliderType definedCollisions] setObject:collisionColliders forKey:[OGColliderType player]];
    
    NSArray *contactColliders = @[[OGColliderType weapon], [OGColliderType key]];
    [[OGColliderType requestedContactNotifications] setObject:contactColliders forKey:[OGColliderType player]];
}

@end
