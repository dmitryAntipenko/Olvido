//
//  OGHealthComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/21/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGHealthComponentDelegate.h"

@interface OGHealthComponent : GKComponent

@property (nonatomic, assign) NSInteger currentHealth;
@property (nonatomic, assign) NSInteger maxHealth;
@property (nonatomic, weak) id<OGHealthComponentDelegate> delegate;

- (void)dealDamage:(NSInteger)damage;
- (void)restoreHealth:(NSInteger)health;
- (void)restoreFullHealth;

@end
