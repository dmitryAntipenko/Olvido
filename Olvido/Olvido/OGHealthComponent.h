//
//  OGHealthComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/21/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGHealthComponent : GKComponent

@property (nonatomic, copy, readonly) NSNumber *currentHealth;

- (instancetype)initWithMaxHealth:(NSNumber *)maxHealth;

- (void)dealDamage:(NSNumber *)damage;
- (void)restoreHealth:(NSNumber *)health;
- (void)kill;
- (void)restoreFullHealth;

@end
