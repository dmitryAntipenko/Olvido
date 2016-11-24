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
    _currentHealth = newHealth;
    
    if (_currentHealth > self.maxHealth)
    {
        _currentHealth = self.maxHealth;
    }
    else if (_currentHealth < kOGHealthComponentMinHealth)
    {
        _currentHealth = kOGHealthComponentMinHealth;
    }
    
    [self.delegate healthDidChange];
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
    
    if (self.currentHealth <= kOGHealthComponentMinHealth)
    {
        [self killEntity];
    }
}

- (void)killEntity
{
    if (self.delegate)
    {
        [self.delegate entityWillDie];
    }
}

@end
