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

#import "OGZPositionEnum.m"
#import "SKColor+OGConstantColors.h"

CGFloat const OGHealthBarComponentYOffset = 40.0;
CGFloat const OGHealthBarComponentBarHeight = 10.0;

CGFloat const OGHealthBarComponentHiddingDuration = 3.0;

@interface OGHealthBarComponent ()

@property (nonatomic, weak) OGHealthComponent *healthComponent;
@property (nonatomic, weak) OGRenderComponent *renderComponent;

@property (nonatomic, strong) SKSpriteNode *barBackgroundNode;
@property (nonatomic, strong) SKSpriteNode *barProgressNode;

@property (nonatomic, assign) CGFloat barNodeWidth;

@property (nonatomic, strong) SKAction *hiddingAction;

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
        
        _hiddingAction = [SKAction waitForDuration:OGHealthBarComponentHiddingDuration];
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
    self.barBackgroundNode.position = CGPointMake(0.0, entityNodeHeight / 2.0 + OGHealthBarComponentYOffset);
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
    self.barProgressNode.size = CGSizeMake([self progressBarWidth], OGHealthBarComponentBarHeight);
    
    [self.barBackgroundNode runAction:self.hiddingAction completion:^()
    {
        self.barBackgroundNode.hidden = YES;
    }];
}

#pragma mark - Getters

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

@end
