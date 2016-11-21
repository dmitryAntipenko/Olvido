//
//  OGRulesComponent.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGRulesComponent.h"
#import "OGEnemyEntity.h"
#import "OGGameScene.h"
#import "OGRenderComponent.h"
#import "OGEntitySnapshot.h"

CGFloat const kOGRulesComponentRulesUpdateWaitDuration = 1.0;
NSString *const kOGRulesComponentRuleSystemStateSnapshot = @"snapshot";

@interface OGRulesComponent ()

@property (nonatomic, strong) GKRuleSystem *ruleSystem;
@property (nonatomic, assign) NSTimeInterval timeSinceRulesUpdate;

@end

@implementation OGRulesComponent

#pragma mark - Inits
- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _timeSinceRulesUpdate = 0.0;
    }
    
    return self;
}

- (instancetype)initWithRules:(NSArray<GKRule *> *)rules
{
    self = [super init];
    
    if (self)
    {
        _timeSinceRulesUpdate = 0.0;
        [self.ruleSystem addRulesFromArray:rules];
    }
    
    return self;
}

#pragma mark - Update
- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    self.timeSinceRulesUpdate += seconds;
    
    if (self.timeSinceRulesUpdate > kOGRulesComponentRulesUpdateWaitDuration)
    {
        self.timeSinceRulesUpdate = 0.0;
        
        if ([self.entity isMemberOfClass:[OGEnemyEntity class]])
        {
            OGGameScene *scene = (OGGameScene *) ((OGEnemyEntity *) self.entity).renderComponent.node.scene;
            OGEntitySnapshot *entitySnapshot = [scene entitySnapshotWithEntity:self.entity];
            
            [self.ruleSystem reset];
            
            self.ruleSystem.state[kOGRulesComponentRuleSystemStateSnapshot] = entitySnapshot;
            
            [self.ruleSystem evaluate];
            
            
            if (self.delegate)
            {
                [self.delegate rulesComponentWithRulesComponent:self ruleSystem:self.ruleSystem];
            }
        }
    }
}

#pragma mark - Getters
- (GKRuleSystem *)ruleSystem
{
    if (!_ruleSystem)
    {
        _ruleSystem = [[GKRuleSystem alloc] init];
    }
    
    return _ruleSystem;
}

@end
