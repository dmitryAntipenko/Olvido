//
//  OGPlayerEntity+OGPlayerEntityResources.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/13/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerEntity.h"

@interface OGPlayerEntity (OGPlayerEntityResources) <OGResourceLoadable>

+ (void)loadResourcesWithCompletionHandler:(void (^)(void))completionHandler;

+ (NSDictionary *)sOGPlayerEntityAnimations;
+ (NSDictionary *)sOGPlayerEntityAppearTextures;
+ (CGSize)textureSize;

@end
