//
//  OGFuzzyEnemyRule.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGFuzzyEnemyRule.h"
#import "OGEntitySnapshot.h"

NSString *const kOGFuzzyEnemyRuleSystemStateSnapshot = @"snapshot";

@implementation OGFuzzyEnemyRule

- (instancetype)init
{
    return [self initWithFact:kOGFuzzyEnemyRuleNoneFact];
}

- (instancetype)initWithFact:(OGFuzzyEnemyRuleFact)fact
{
    self = [super init];
    
    if (self)
    {
        _fact = fact;
    }
    
    return self;
}

- (CGFloat)grade
{
    return 0.0;
}

- (BOOL)evaluatePredicateWithSystem:(GKRuleSystem *)system
{
    self.snapshot = (OGEntitySnapshot *) system.state[kOGFuzzyEnemyRuleSystemStateSnapshot];
    
    BOOL result = NO;
    
    if ([self grade] >= 0.0)
    {
        result = YES;
    }
    
    return result;
}

- (void)performActionWithSystem:(GKRuleSystem *)system
{
    [system assertFact:@(self.fact) grade:[self grade]];
}

@end
