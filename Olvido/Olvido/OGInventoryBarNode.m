//
//  OGInventoryBarNode.m
//  Olvido
//
//  Created by Алексей Подолян on 11/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGInventoryBarNode.h"
#import "OGInventoryComponent.h"
#import "OGZPositionEnum.h"
#import "OGRenderComponent.h"
#import "OGPlayerEntity.h"
#import "OGHUDNode.h"

CGFloat const OGInventoryBarNodeMaxHeight = 256;
CGFloat const OGInventoryBarNodeMaxWidthFactor = 0.5;
CGFloat const OGInventoryBarNodeDesiredHeightFactor = 0.0625;
CGFloat const OGInventoryBarNodeDefaultXPosition = 0.0;
CGFloat const OGInventoryBarNodeDefaultItemNodeYPosition = 0.0;
CGFloat const OGInventoryBarNodeHidingTimeInterval = 0.2;
CGFloat const OGInventoryBarNodeHidingDx = 0.0;
NSString *const OGInventoryBarNodeHidingActionKey = @"HidingAction";
NSString *const OGInventoryBarNodeShowingActionKey = @"ShowingAction";
CGFloat const OGInventoryBarNodeHidingZoneWidth = 50.0;

@interface OGInventoryBarNode () <OGInventoryComponentDelegate>
{
    OGHUDNode *_hudNode;
}

@property (nonatomic, strong) OGInventoryComponent *inventoryComponent;
@property (nonatomic, assign) CGFloat itemSizeLength;
@property (nonatomic, assign) CGRect hideTrigger;
@property (nonatomic, assign) CGSize screenSize;
@property (nonatomic, assign) BOOL customHidden;
@property (nonatomic, assign) BOOL needsUpdate;

@end

@implementation OGInventoryBarNode

#pragma mark - Initialising

- (instancetype)initWithInventoryComponent:(OGInventoryComponent *)inventoryComponent screenSize:(CGSize)screenSize
{
    if (inventoryComponent)
    {
        CGSize defaultSize = CGSizeMake(768, 256);
        
        self = [self initWithColor:[[SKColor lightGrayColor] colorWithAlphaComponent:0.5] size:defaultSize];
        
        if (self)
        {
            _inventoryComponent = inventoryComponent;
            _inventoryComponent.inventoryComponentDelegate = self;
            _screenSize = screenSize;
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

+ (instancetype)inventoryBarNodeWithInventoryComponent:(OGInventoryComponent *)inventoryComponent screenSize:(CGSize)screenSize
{
    return [[self alloc] initWithInventoryComponent:inventoryComponent screenSize:screenSize];
}

#pragma mark - Getters & Setters

- (void)setHudNode:(OGHUDNode *)hudNode
{
    _hudNode = hudNode;
}

- (OGHUDNode *)hudNode
{
    return _hudNode;
}

#pragma mark - OGHUDElement

- (void)didAddToHUD
{
    
}

- (void)update
{
    if (self.needsUpdate)
    {
        [self updateInventoryBarSize];
        [self updateInventoryBarItems];
        self.needsUpdate = NO;
    }
}

#pragma mark - Update

- (void)updateConstraints
{
    self.needsUpdate = YES;
}

- (void)updateInventoryBarSize
{
    CGSize frameSize = CGSizeZero;
    
    if (self.scene)
    {
        frameSize = self.scene.frame.size;
    }
    
    CGFloat height = frameSize.height * OGInventoryBarNodeDesiredHeightFactor;
    
    if (height > OGInventoryBarNodeMaxHeight)
    {
        height = OGInventoryBarNodeMaxHeight;
    }
    
    CGFloat width = height * self.inventoryComponent.capacity;
    
    CGFloat widthWithFactor = frameSize.width * OGInventoryBarNodeMaxWidthFactor;
    
    if (width > widthWithFactor)
    {
        width = widthWithFactor;
        height = widthWithFactor / self.inventoryComponent.capacity;
    }
    
    self.size = CGSizeMake(width, height);
    self.position = CGPointMake(OGInventoryBarNodeDefaultXPosition, (height - frameSize.height) / 2);
    
    self.itemSizeLength = height;
    
    self.hideTrigger = CGRectMake(self.position.x - self.size.width / 2 - OGInventoryBarNodeHidingZoneWidth,
                                  self.position.y - self.size.height / 2,
                                  self.size.width + 2 * OGInventoryBarNodeHidingZoneWidth,
                                  self.size.height + OGInventoryBarNodeHidingZoneWidth);
}

- (void)updateInventoryBarItems
{
    [self removeAllChildren];
    
    if (self.inventoryComponent)
    {
        [self.inventoryComponent.inventoryItems enumerateObjectsUsingBlock:^(id<OGInventoryItem>  item, NSUInteger idx, BOOL * _Nonnull stop)
         {
             [self updateCellWithItem:item atIndex:idx];
         }];
    }
}

- (void)updateCellWithItem:(id<OGInventoryItem>)item atIndex:(NSUInteger)index
{
    SKTexture *itemTexture = item.texture;
    
    CGSize itemSize = CGSizeZero;
    
    if (itemTexture && itemTexture.size.width > 0 && itemTexture.size.height > 0)
    {
        CGFloat widthHeightFactor = itemTexture.size.width / itemTexture.size.height;
        
        if (widthHeightFactor > 1)
        {
            itemSize = CGSizeMake(self.itemSizeLength, self.itemSizeLength / widthHeightFactor);
        }
        else
        {
            itemSize = CGSizeMake(self.itemSizeLength * widthHeightFactor, self.itemSizeLength);
        }
        
        SKSpriteNode *itemNode = [SKSpriteNode spriteNodeWithTexture:itemTexture size:itemSize];
        CGFloat xPosition = (self.itemSizeLength - self.size.width) / 2 + self.itemSizeLength * index;
        
        itemNode.position = CGPointMake(xPosition, OGInventoryBarNodeDefaultItemNodeYPosition);
        
        [self addChild:itemNode];
    }
}

- (void)hide
{
    [self removeActionForKey:OGInventoryBarNodeShowingActionKey];
    
    SKAction *hidingAction = [SKAction moveToY: -(self.screenSize.height + self.size.height) / 2 duration:OGInventoryBarNodeHidingTimeInterval];
    [self runAction:hidingAction withKey:OGInventoryBarNodeHidingActionKey];
    
    self.customHidden = YES;
}

- (void)show
{
    [self removeActionForKey:OGInventoryBarNodeHidingActionKey];

    SKAction *showingAction = [SKAction moveToY:(self.size.height - self.screenSize.height) / 2 duration:OGInventoryBarNodeHidingTimeInterval];
    [self runAction:showingAction withKey:OGInventoryBarNodeShowingActionKey];
    
    self.customHidden = NO;
}

- (void)checkPlayerPosition
{
    if (self.hudNode.playerEntity)
    {
        SKNode *renderComponentNode = ((OGRenderComponent *) [self.hudNode.playerEntity componentForClass:[OGRenderComponent class]]).node;
        
        CGPoint playerPosition = [renderComponentNode.parent convertPoint:renderComponentNode.position toNode:self.parent];
        
        if (CGRectContainsPoint(self.hideTrigger, playerPosition))
        {
            if (!self.customHidden)
            {
                [self hide];
            }
        }
        else if (self.customHidden)
        {
            [self show];
        }
    }
}

#pragma mark - OGInventoryComponentDelegate

- (void)inventoryDidUpdate
{
    [self updateInventoryBarItems];
}

@end
