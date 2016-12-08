//
//  OGPeriodicalZone.m
//  Olvido
//
//  Created by Алексей Подолян on 12/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGPeriodicalZone.h"
#import "OGHealthComponent.h"
#import "OGTimer.h"

NSTimeInterval const OGPeriodicalZoneDamageZonePeriod = 0.3;
NSInteger const OGPeriodicalZoneDefaultDamage = 1.0;

@interface OGPeriodicalZone ()

@property (nonatomic, strong) NSMutableArray<GKEntity *> *entities;
@property (nonatomic, strong) OGTimer *timer;
@property (nonatomic, strong) void (^actionBlock)(GKEntity *entity);

@end

@implementation OGPeriodicalZone

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
            affectingColliderTypes:(NSArray<OGColliderType *> *)affectingColliderTypes
                       actionBlock:(void (^)(GKEntity *entity))actionBlock
                          interval:(NSTimeInterval)interval
{
    if (actionBlock && interval > 0)
    {
        self = [self initWithSpriteNode:spriteNode affectingColliderTypes:affectingColliderTypes];
        
        if (self)
        {
            _actionBlock = actionBlock;
            _entities = [[NSMutableArray alloc] init];
            
            _timer = [[OGTimer alloc] init];
            [_timer startWithInterval:interval selector:@selector(performAction) sender:self];
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
                       actionBlock:(void (^)(GKEntity *entity))actionBlock
                          interval:(NSTimeInterval)interval
{
    if (actionBlock && interval > 0)
    {
        self = [self initWithSpriteNode:spriteNode];
        
        if (self)
        {
            _actionBlock = actionBlock;
            _entities = [[NSMutableArray alloc] init];
            
            _timer = [[OGTimer alloc] init];
            [_timer startWithInterval:interval selector:@selector(performAction) sender:self];
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

- (void)performAction
{
    for (GKEntity *entity in self.entities)
    {
        self.actionBlock(entity);
    }
}

#pragma mark - OGContactNotifiableType

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    [self.entities addObject:entity];
}

- (void)contactWithEntityDidEnd:(GKEntity *)entity
{
    [self.entities removeObject:entity];
}

- (void)pause
{
    [self.timer pause];
}

- (void)resume
{
    [self.timer resume];
}

#pragma mark - Factory methods

+ (instancetype)damageZoneWithSpriteNode:(SKSpriteNode *)spriteNode
{
    void (^block)(GKEntity *entity) = ^(GKEntity *entity)
    {
        OGHealthComponent *healthComponent = (OGHealthComponent *)[entity componentForClass:[OGHealthComponent class]];
        [healthComponent dealDamage:OGPeriodicalZoneDefaultDamage];
    };

    return [[self alloc] initWithSpriteNode:spriteNode
                                actionBlock:block
                                   interval:OGPeriodicalZoneDamageZonePeriod];
}

@end
