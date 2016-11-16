//
//  OGRulesComponentDelegate.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#ifndef OGRulesComponentDelegate_h
#define OGRulesComponentDelegate_h

@class OGRulesComponent;

@protocol OGRulesComponentDelegate <NSObject>

- (void)rulesComponentWithRulesComponent:(OGRulesComponent *)rulesComponent ruleSystem:(GKRuleSystem *)ruleSystem;

@end

#endif /* OGRulesComponentDelegate_h */
