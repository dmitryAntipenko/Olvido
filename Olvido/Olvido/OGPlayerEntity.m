//
//  OGPlayerEntity.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerEntity.h"
#import "OGRenderComponent.h"
#import "OGHealthComponent.h"
#import "OGIntelligenceComponent.h"
#import "OGInputComponent.h"
#import "OGMovementComponent.h"
#import "OGAnimationComponent.h"

#import "OGPlayerEntityConfiguration.h"

@implementation OGPlayerEntity

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _render = [[OGRenderComponent alloc] init];
        [self addComponent:_render];
        
        _health = [[OGHealthComponent alloc] init];
        _health.maxHealth = playerConfiguration.maxHealth;
        _health.currentHealth = playerConfiguration.currentHealth;
        [self addComponent:_health];
        
        _movement = [[OGMovementComponent alloc] init];
        [self addComponent:_movement];
        
        _input = [[OGInputComponent alloc] init];
        _input.enabled = YES;
        [self addComponent:_input];
        
        _intelligence = [[OGIntelligenceComponent alloc] initWithStates:nil];
        
        _animation = [[OGAnimationComponent alloc] init];
        [self addComponent:_animation];
        
        //[self addComponent:_intelligence];
    }
    
    return self;
}

@end
