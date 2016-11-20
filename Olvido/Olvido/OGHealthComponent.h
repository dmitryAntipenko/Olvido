//
//  OGHealthComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/21/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGHealthComponent : GKComponent

@property (nonatomic, assign) GKInspectable NSInteger currentHealth;
@property (nonatomic, assign) GKInspectable NSInteger maxHealth;

- (void)dealDamage:(NSInteger)damage;
- (void)restoreHealth:(NSInteger)health;
- (void)kill;
- (void)restoreFullHealth;

@end
