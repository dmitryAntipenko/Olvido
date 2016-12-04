//
//  OGHealthBarComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/24/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGHealthBarComponent.h"
#import "OGHealthComponent.h"
#import "OGRenderComponent.h"
#import "OGAnimationComponent.h"

#import "OGZPositionEnum.m"
#import "SKColor+OGConstantColors.h"

CGFloat const OGHealthBarComponentBarHeight = 10.0;

CGFloat const OGHealthBarComponentHiddingDuration = 3.0;

NSString *const OGHealthBarComponentHiddingActionKey = @"hidingActionKey";

@interface OGHealthBarComponent ()

@property (nonatomic, weak) OGHealthComponent *healthComponent;
@property (nonatomic, weak) OGRenderComponent *renderComponent;
@property (nonatomic, weak) OGAnimationComponent *animationComponent;

@property (nonatomic, strong) SKSpriteNode *barBackgroundNode;
@property (nonatomic, strong) SKSpriteNode *barProgressNode;

@property (nonatomic, assign) CGFloat barNodeWidth;

@property (nonatomic, strong) NSTimer *hiddingBarTimer;
@property (nonatomic, assign) BOOL shouldAppear;
@property (nonatomic, assign) NSTimeInterval elapsedTime;

@end

@implementation OGHealthBarComponent

#pragma mark - Initializing

+ (instancetype)healthBarComponent
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _barBackgroundNode = [SKSpriteNode node];
        _barProgressNode = [SKSpriteNode node];
    }
    
    return self;
}

#pragma mark -

- (void)didAddToEntity
{
    [super didAddToEntity];
    
    CGFloat entityNodeWidth = self.renderComponent.node.calculateAccumulatedFrame.size.width;
    CGFloat entityNodeHeight = self.renderComponent.node.calculateAccumulatedFrame.size.height;
    
    self.barNodeWidth = entityNodeWidth;
    
    self.barBackgroundNode.size = CGSizeMake(entityNodeWidth, OGHealthBarComponentBarHeight);
    self.barBackgroundNode.color = [SKColor gameBlack];
    self.barBackgroundNode.position = CGPointMake(0.0, entityNodeHeight / 2.0);
    self.barBackgroundNode.zPosition = OGZPositionCategoryPhysicsWorld;
    
    self.barProgressNode.size = CGSizeMake([self progressBarWidth], OGHealthBarComponentBarHeight);
    self.barProgressNode.color = [SKColor gameGreen];
    self.barProgressNode.anchorPoint = [self progressBarNodeAnchorPoint];
    self.barProgressNode.position = [self progressBarNodePosition];
    self.barProgressNode.zPosition = OGZPositionCategoryPhysicsWorld;
    
    self.barBackgroundNode.hidden = YES;
    
    [self.barBackgroundNode addChild:self.barProgressNode];
    [self.renderComponent.node addChild:self.barBackgroundNode];
}

- (void)redrawBarNode
{
    self.barBackgroundNode.hidden = NO;
    self.shouldAppear = YES;
    [self.barBackgroundNode removeActionForKey:OGHealthBarComponentHiddingActionKey];
    
    self.barProgressNode.size = CGSizeMake([self progressBarWidth], OGHealthBarComponentBarHeight);
    
    CGFloat entityNodeHalfHeight = self.animationComponent.spriteNode.calculateAccumulatedFrame.size.height;
    self.barBackgroundNode.position = CGPointMake(0.0, entityNodeHalfHeight);
}

#pragma mark - Update

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    if (self.shouldAppear)
    {
        self.elapsedTime += seconds;
        
        if (self.elapsedTime >= OGHealthBarComponentHiddingDuration)
        {
            self.barBackgroundNode.hidden = YES;
            self.shouldAppear = NO;
//            self.elapsedTime = 0.0;
        }
    }
}

#pragma mark - Getters & Setters

- (void)setShouldAppear:(BOOL)shouldAppear
{
    _shouldAppear = shouldAppear;
    
    self.elapsedTime = 0.0;
}

- (CGFloat)progressBarWidth
{
    return self.healthComponent.currentHealth / (CGFloat) self.healthComponent.maxHealth * self.barNodeWidth;
}

- (CGPoint)progressBarNodePosition
{
    return CGPointMake(-self.barNodeWidth / 2.0, 0.0);
}

- (CGPoint)progressBarNodeAnchorPoint
{
    return CGPointMake(0.0, 0.5);
}

- (OGHealthComponent *)healthComponent
{
    if (!_healthComponent)
    {
        _healthComponent = (OGHealthComponent *) [self.entity componentForClass:[OGHealthComponent class]];
    }
    
    return _healthComponent;
}

- (OGRenderComponent *)renderComponent
{
    if (!_renderComponent)
    {
        _renderComponent = (OGRenderComponent *) [self.entity componentForClass:[OGRenderComponent class]];
    }
    
    return _renderComponent;
}

- (OGAnimationComponent *)animationComponent
{
    if (!_animationComponent)
    {
        _animationComponent = (OGAnimationComponent *) [self.entity componentForClass:[OGAnimationComponent class]];
    }
    
    return _animationComponent;
}

- (void)dealloc
{
    if (_hiddingBarTimer)
    {
        [_hiddingBarTimer invalidate];        
    }
}

@end
