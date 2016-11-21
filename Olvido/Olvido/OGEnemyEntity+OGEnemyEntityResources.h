//
//  OGEnemyEntity+OGEnemyEntityResources.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyEntity.h"
#import "OGResourceLoadable.h"

@interface OGEnemyEntity (OGEnemyEntityResources) <OGResourceLoadable>

+ (NSDictionary *)sOGEnemyEntityAnimations;

@end
