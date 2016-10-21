//
//  OGHealthComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/21/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGHealthComponent.h"

CGFloat const kOGHealthComponentMinHealth = 0.0;

@interface OGHealthComponent ()

@property (nonatomic, copy) NSNumber *maxHealth;
@property (nonatomic, copy, readwrite) NSNumber *currentHealth;

@end

@implementation OGHealthComponent

- (instancetype)initWithMaxHealth:(NSNumber *)maxHealth
{
    if (maxHealth && maxHealth.doubleValue > kOGHealthComponentMinHealth)
    {
        self = [super init];
        
        if (self)
        {
            _maxHealth = [maxHealth copy];
            _currentHealth = [maxHealth copy];
        }
    }
    else
    {
        [self release];
        self = nil;
    }
    
    return self;
}

- (void)setCurrentHealth:(NSNumber *)newHealth
{
    if (_currentHealth != newHealth)
    {
        if (newHealth.doubleValue > self.maxHealth.doubleValue)
        {
            _currentHealth = [self.maxHealth copy];
        }
        else if (newHealth.doubleValue < kOGHealthComponentMinHealth)
        {
            _currentHealth = @(kOGHealthComponentMinHealth);
        }
        else
        {
            _currentHealth = [newHealth copy];
        }
    }
}

- (void)restoreHealth:(NSNumber *)health
{
    self.currentHealth = @(self.currentHealth.doubleValue + health.doubleValue);
}

- (void)restoreFullHealth
{
    self.currentHealth = self.maxHealth;
}

- (void)dealDamage:(NSNumber *)damage
{
    self.currentHealth = @(self.currentHealth.doubleValue - damage.doubleValue);
}

- (void)kill
{
    self.currentHealth = @(kOGHealthComponentMinHealth);
}

- (void)dealloc
{
    [_currentHealth release];
    [_maxHealth release];
    
    [super dealloc];
}

@end
