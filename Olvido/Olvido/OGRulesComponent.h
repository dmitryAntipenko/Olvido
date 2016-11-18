//
//  OGRulesComponent.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGRulesComponentDelegate.h"

extern NSString *const kOGRulesComponentRuleSystemStateSnapshot;

@interface OGRulesComponent : GKComponent

- (instancetype)initWithRules:(NSArray<GKRule *> *)rules;

@property (nonatomic, weak) id<OGRulesComponentDelegate> delegate;

@end
