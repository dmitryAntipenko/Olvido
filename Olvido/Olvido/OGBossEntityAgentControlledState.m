//
//  OGBossEntityAgentControlledState.m
//  Olvido
//
//  Created by Александр Песоцкий on 12/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGBossEntityAgentControlledState.h"
#import "OGEnemyEntity.h"

#import "OGRenderComponent.h"
#import "OGWeaponComponent.h"

CGFloat const OGBossEntityAgentControlledStateShootingDistance = 300.0;

@implementation OGBossEntityAgentControlledState

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    OGRenderComponent *huntTargetRenderComponent = (OGRenderComponent *) [self.enemyEntity.huntAgent.entity componentForClass:[OGRenderComponent class]];
    
    if (huntTargetRenderComponent &&
        [self.enemyEntity distanceToAgentWithOtherAgent:self.enemyEntity.huntAgent] >= OGBossEntityAgentControlledStateShootingDistance)
    {
        self.weaponComponent.weapon.target = huntTargetRenderComponent.node;
        self.weaponComponent.shouldAttack = YES;
    }
    else
    {
        self.weaponComponent.shouldAttack = NO;
    }
    
}
@end
