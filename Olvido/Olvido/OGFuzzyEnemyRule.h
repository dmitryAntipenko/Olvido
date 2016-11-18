//
//  OGFuzzyEnemyRule.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
@class OGEntitySnapshot;

typedef NS_ENUM(NSUInteger, OGFuzzyEnemyRuleFact)
{
    kOGFuzzyEnemyRuleNoneFact,
    kOGFuzzyEnemyRuleFactPlayerNear,
    kOGFuzzyEnemyRuleFactPlayerMedium,
    kOGFuzzyEnemyRuleFactPlayerFar
};

@interface OGFuzzyEnemyRule : GKRule

@property (nonatomic, strong) OGEntitySnapshot *snapshot;
@property (nonatomic, assign) OGFuzzyEnemyRuleFact fact;

- (instancetype)initWithFact:(OGFuzzyEnemyRuleFact)fact NS_DESIGNATED_INITIALIZER;

- (CGFloat)grade;

@end
