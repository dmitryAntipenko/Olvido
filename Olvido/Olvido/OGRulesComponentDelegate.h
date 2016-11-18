//
//  OGRulesComponentDelegate.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/18/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#ifndef OGRulesComponentDelegate_h
#define OGRulesComponentDelegate_h

#import <GameplayKit/GameplayKit.h>
@class OGRulesComponent;

@protocol OGRulesComponentDelegate <NSObject>

- (void)rulesComponentWithRulesComponent:(OGRulesComponent *)rulesComponent ruleSystem:(GKRuleSystem *)ruleSystem;

@end

#endif /* OGRulesComponentDelegate_h */
