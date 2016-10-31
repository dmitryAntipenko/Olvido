//
//  OGDestroyableComponent.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGDestroyableComponent.h"
#import "OGHealthComponent.h"

@implementation OGDestroyableComponent

- (void)dealDamage:(NSUInteger)damage
{
    if (self.healthComponent)
    {
        [self.healthComponent dealDamage:damage];
        
        if (self.healthComponent.currentHealth <= 0)
        {
            [self destroyNode];
        }
    }
}

- (void)destroyNode
{
    SKNode *node = ((GKSKNodeComponent *)[self.entity componentForClass:[GKSKNodeComponent class]]).node;
    [node removeFromParent];
}

- (void)dealloc
{
    [_healthComponent release];
    
    [ super dealloc];
}

@end
