//
//  OGHealthComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/21/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGHealthComponent.h"

NSInteger const kOGHealthComponentMinHealth = 0;

@implementation OGHealthComponent

- (void)setCurrentHealth:(NSInteger)newHealth
{
    if (newHealth > self.maxHealth)
    {
        _currentHealth = self.maxHealth;
    }
    else if (newHealth < kOGHealthComponentMinHealth)
    {
        [self kill];
    }
    else
    {
        _currentHealth = newHealth;
    }
}

- (void)restoreHealth:(NSInteger)health
{
    self.currentHealth += health;
}

- (void)restoreFullHealth
{
    self.currentHealth = self.maxHealth;
}

- (void)dealDamage:(NSInteger)damage
{
    self.currentHealth -= damage;    
}

- (void)kill
{
    if (self.delegate)
    {
        [self.delegate entityWillDie];
    }
}

@end
