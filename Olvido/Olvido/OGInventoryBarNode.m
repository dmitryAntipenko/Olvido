//
//  OGInventoryBarNode.m
//  Olvido
//
//  Created by Алексей Подолян on 11/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGInventoryBarNode.h"
#import "OGInventoryComponent.h"
#import "OGZPositionEnum.m"
#import "OGRenderComponent.h"
#import "OGPlayerEntity.h"

CGFloat const kOGInventoryBarNodeMaxHeight = 256;
CGFloat const kOGInventoryBarNodeMaxWidthFactor = 0.5;
CGFloat const kOGInventoryBarNodeDesiredHeightFactor = 0.0625;
CGFloat const kOGInventoryBarNodeDefaultXPosition = 0.0;
CGFloat const kOGInventoryBarNodeDefaultItemNodeYPosition = 0.0;
CGFloat const kOGInventoryBarNodeHidingTimeInterval = 0.2;
CGFloat const kOGInventoryBarNodeHidingDx = 0.0;
NSString *const kOGInventoryBarNodeHidingActionKey = @"HidingAction";
NSString *const kOGInventoryBarNodeShowingActionKey = @"ShowingAction";
CGFloat const kOGInventoryBarNodeHidingZoneWidth = 50.0;

@interface OGInventoryBarNode ()

@property (nonatomic, strong) OGInventoryComponent *inventoryComponent;
@property (nonatomic, assign) CGFloat itemSizeLength;
@property (nonatomic, assign) CGRect hideTrigger;
@property (nonatomic, assign, readonly) CGRect parentFrame;
@property (nonatomic, assign) BOOL customHidden;

@end

@implementation OGInventoryBarNode

@synthesize parentFrame = _parentFrame;

- (instancetype)initWithInventoryComponent:(OGInventoryComponent *)inventoryComponent
{
    if (inventoryComponent)
    {
        CGSize defaultSize = CGSizeMake(768, 256);
        
        self = [self initWithColor:[[SKColor lightGrayColor] colorWithAlphaComponent:0.5] size:defaultSize];
        
        if (self)
        {
            _inventoryComponent = inventoryComponent;
            [_inventoryComponent addObserver:self forKeyPath:kOGInventoryComponentInventoryItemsKeyPath
                                     options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial
                                     context:nil];
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

+ (instancetype)inventoryBarNodeWithInventoryComponent:(OGInventoryComponent *)inventoryComponent
{
    return [[self alloc] initWithInventoryComponent:inventoryComponent];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:kOGInventoryComponentInventoryItemsKeyPath])
    {
        [self updateInventoryBarItems];
    }
}

- (void)dealloc
{
    [_inventoryComponent removeObserver:self forKeyPath:kOGInventoryComponentInventoryItemsKeyPath];
}

#pragma mark - Update

- (void)updateConstraints
{
    [self updateInventoryBarSize];
    [self updateInventoryBarItems];
}

- (void)updateInventoryBarSize
{
    CGSize frameSize = CGSizeZero;
    
    if (self.scene)
    {
        frameSize = self.scene.frame.size;
    }
    
    CGFloat height = frameSize.height * kOGInventoryBarNodeDesiredHeightFactor;
    
    if (height > kOGInventoryBarNodeMaxHeight)
    {
        height = kOGInventoryBarNodeMaxHeight;
    }
    
    CGFloat width = height * self.inventoryComponent.capacity;
    
    CGFloat widthWithFactor = frameSize.width * kOGInventoryBarNodeMaxWidthFactor;
    
    if (width > widthWithFactor)
    {
        width = widthWithFactor;
        height = widthWithFactor / self.inventoryComponent.capacity;
    }
    
    self.size = CGSizeMake(width, height);
    self.position = CGPointMake(kOGInventoryBarNodeDefaultXPosition, (height - frameSize.height) / 2);    
    
    self.itemSizeLength = height;
    
    self.hideTrigger = CGRectMake(self.position.x - self.size.width / 2 - kOGInventoryBarNodeHidingZoneWidth,
                                  self.position.y - self.size.height / 2,
                                  self.size.width + 2 * kOGInventoryBarNodeHidingZoneWidth,
                                  self.size.height + kOGInventoryBarNodeHidingZoneWidth);
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
        
        itemNode.position = CGPointMake(xPosition, kOGInventoryBarNodeDefaultItemNodeYPosition);
        
        [self addChild:itemNode];
    }
}

- (void)hide
{
    [self removeActionForKey:kOGInventoryBarNodeShowingActionKey];
    
    SKAction *hidingAction = [SKAction moveToY: -(self.parentFrame.size.height + self.size.height) / 2 duration:kOGInventoryBarNodeHidingTimeInterval];
    
    [self runAction:hidingAction withKey:kOGInventoryBarNodeHidingActionKey];
    
    self.customHidden = YES;
}

- (void)show
{
    [self removeActionForKey:kOGInventoryBarNodeHidingActionKey];
    
    SKAction *showingAction = [SKAction moveToY:(self.size.height - self.parentFrame.size.height) / 2 duration:kOGInventoryBarNodeHidingTimeInterval];
    [self runAction:showingAction withKey:kOGInventoryBarNodeShowingActionKey];
    
    self.customHidden = NO;
}

- (void)checkPlayerPosition
{
    CGPoint playerPosition = [self.playerEntity.render.node.parent convertPoint:self.playerEntity.render.node.position toNode:self.parent];
    
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

- (CGRect)parentFrame
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
        {
            _parentFrame = [self.parent calculateAccumulatedFrame];
        });
    
    return _parentFrame;
}

@end
