//
//  OGWeaponStatisticsNode.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/29/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGWeaponStatisticsNode.h"
#import "OGWeaponEntity.h"
#import "OGPlayerEntity.h"
#import "OGHUDNode.h"

CGFloat const OGWeaponStatisticsNodeOffset = 60.0;

@interface OGWeaponStatisticsNode ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSValue *> *weaponProperties;
@property (nonatomic, strong) NSMutableDictionary<NSString *, SKLabelNode *> *labelNodes;

@end

@implementation OGWeaponStatisticsNode

#pragma mark - Initializing

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _weaponProperties = [NSMutableDictionary dictionary];
        _labelNodes = [NSMutableDictionary dictionary];
    }
    
    return self;
}

#pragma mark - OGWeaponComponentDelegate

- (void)weaponWasTakenWithProperties:(NSDictionary *)properties
{
    for (NSString *key in properties)
    {
        [self addPropertyWithKey:key value:properties[key]];
    }
}

- (void)weaponWasRemoved
{
    for (SKLabelNode *labelNode in self.labelNodes)
    {
        [labelNode removeFromParent];
    }
    
    [self.labelNodes removeAllObjects];
    [self.weaponProperties removeAllObjects];
}

- (void)weaponDidUpdateKey:(NSString *)key withValue:(NSValue *)value
{
    [self addPropertyWithKey:key value:value];
}

- (void)addPropertyWithKey:(NSString *)key value:(NSValue *)value
{
    self.weaponProperties[key] = value;
    
    if (!self.labelNodes[key])
    {
        self.labelNodes[key] = [SKLabelNode node];
        [self addChild:self.labelNodes[key]];
    }
    
    [self redrawPropertyWithKey:key];
}

#pragma mark - OGHUDElement

- (void)didAddToHUD
{
    self.anchorPoint = CGPointMake(0.0, 1.0);
    
    CGRect parentFrame = self.hudNode.frame;
    self.position = CGPointMake(CGRectGetMinX(parentFrame),
                                CGRectGetMaxY(parentFrame));
}

- (void)update
{
    
}

- (void)redrawPropertyWithKey:(NSString *)key
{
    CGFloat yPerLabel = 30.0;
    CGFloat currentPositionY = -OGWeaponStatisticsNodeOffset - yPerLabel * [self.labelNodes.allKeys indexOfObject:key];
    
    self.labelNodes[key].horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.labelNodes[key].position = CGPointMake(OGWeaponStatisticsNodeOffset, currentPositionY);
    self.labelNodes[key].text = [NSString stringWithFormat:@"%@: %@", key, self.weaponProperties[key]];
}

@end
