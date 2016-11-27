//
//  OGPlayerFarRule.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerFarRule.h"
#import "OGEntitySnapshot.h"

@implementation OGPlayerFarRule

- (instancetype)init
{
    return [super initWithFact:OGFuzzyEnemyRuleFactPlayerFar];
}

- (CGFloat)grade
{
    CGFloat result = 0.0;
    
    if (self.snapshot.playerTarget)
    {
        CGFloat distance = [[self.snapshot.playerTarget valueForKey:OGEntitySnapshotPlayerBotTargetDistanceKey] floatValue];
        
        CGFloat oneThird = self.snapshot.proximityFactor / 3;
        
        result = (distance - oneThird) / oneThird;
    }
    
    return result;
}

@end
