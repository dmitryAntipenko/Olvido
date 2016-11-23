//
//  OGZombieMan.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/21/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEnemyEntity.h"
#import "OGResourceLoadable.h"

@class OGIntelligenceComponent;
@class OGTrailComponent;

@interface OGZombie : OGEnemyEntity <OGResourceLoadable>

@property (nonatomic, strong) OGIntelligenceComponent *intelligenceComponent;
@property (nonatomic, strong) OGTrailComponent *trailComponent;

+ (NSDictionary *)sOGZombieAnimations;

@end
