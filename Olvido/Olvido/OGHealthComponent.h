//
//  OGHealthComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/21/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGHealthComponent : GKComponent

@property (nonatomic, assign) GKInspectable NSUInteger currentHealth;
@property (nonatomic, assign) GKInspectable NSUInteger maxHealth;

- (void)dealDamage:(NSUInteger)damage;
- (void)restoreHealth:(NSUInteger)health;
- (void)kill;
- (void)restoreFullHealth;

@end
