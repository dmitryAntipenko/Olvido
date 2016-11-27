//
//  OGFuzzyEnemyRule.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

typedef NS_ENUM(NSUInteger, OGFuzzyEnemyRuleFact)
{
    OGFuzzyEnemyRuleNoneFact,
    OGFuzzyEnemyRuleFactPlayerNear,
    OGFuzzyEnemyRuleFactPlayerMedium,
    OGFuzzyEnemyRuleFactPlayerFar
};

@class OGEntitySnapshot;

@interface OGFuzzyEnemyRule : GKRule

@property (nonatomic, strong) OGEntitySnapshot *snapshot;
@property (nonatomic, assign) OGFuzzyEnemyRuleFact fact;

- (instancetype)initWithFact:(OGFuzzyEnemyRuleFact)fact NS_DESIGNATED_INITIALIZER;

- (CGFloat)grade;

@end
