//
//  OGHealthComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/21/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGHealthComponent.h"

CGFloat const kOGHealthComponentMinHealth = 0.0;

@implementation OGHealthComponent

- (void)setCurrentHealth:(NSUInteger)newHealth
{
    if (newHealth > self.maxHealth)
    {
        _currentHealth = self.maxHealth;
    }
    else if (newHealth < kOGHealthComponentMinHealth)
    {
        _currentHealth = kOGHealthComponentMinHealth;
    }
    else
    {
        _currentHealth = newHealth;
    }
}

- (void)restoreHealth:(NSUInteger)health
{
    self.currentHealth = self.currentHealth + health;
}

- (void)restoreFullHealth
{
    self.currentHealth = self.maxHealth;
}

- (void)dealDamage:(NSUInteger)damage
{
    self.currentHealth = self.currentHealth - damage;
}

- (void)kill
{
    self.currentHealth = kOGHealthComponentMinHealth;
}

- (void)dealloc
{
    
    [super dealloc];
}

@end
