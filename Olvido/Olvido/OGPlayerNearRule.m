//
//  OGPlayerNearRule.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerNearRule.h"
#import "OGEntitySnapshot.h"

@implementation OGPlayerNearRule

- (instancetype)init
{
    return [super initWithFact:kOGFuzzyEnemyRuleFactPlayerNear];
}

- (CGFloat)grade
{
    CGFloat result = 0.0;
    
    if (self.snapshot.playerTarget)
    {
        CGFloat distance = [[self.snapshot.playerTarget valueForKey:kOGEntitySnapshotPlayerBotTargetDistanceKey] floatValue];

        CGFloat oneThird = self.snapshot.proximityFactor / 3;
        
        result = (oneThird - distance) / oneThird;
    }
    
    return result;
}

@end
