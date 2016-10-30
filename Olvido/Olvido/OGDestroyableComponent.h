//
//  OGDestroyableComponent.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
@class OGHealthComponent;

@interface OGDestroyableComponent : GKComponent

@property (nonatomic, retain) OGHealthComponent *healthComponent;

@end
