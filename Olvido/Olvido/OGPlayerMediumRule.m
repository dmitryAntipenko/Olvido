//
//  OGPlayerMediumRule.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPlayerMediumRule.h"
#import "OGEntitySnapshot.h"

@implementation OGPlayerMediumRule

- (instancetype)init
{
    return [super initWithFact:kOGFuzzyEnemyRuleFactPlayerMedium];
}

- (CGFloat)grade
{
    CGFloat result = 0.0;
    
    if (self.snapshot.playerTarget)
    {
        CGFloat distance = [self.snapshot.playerTarget[kOGEntitySnapshotPlayerBotTargetDistanceKey] floatValue];
        
        CGFloat oneThird = self.snapshot.proximityFactor / 3.0;
        
        result = 1 - (fabs(distance - oneThird) / oneThird);
    }
    
    return result;
}

@end
