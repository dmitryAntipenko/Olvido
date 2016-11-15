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

CGFloat const kOGInventoryBarNodeMaxHeight = 256;
CGFloat const kOGInventoryBarNodeMaxWidthFactor = 0.5;
CGFloat const kOGInventoryBarNodeDesiredHeightFactor = 0.0625;
CGFloat const kOGInventoryBarNodeDefaultXPosition = 0.0;
CGFloat const kOGInventoryBarNodeDefaultItemNodeYPosition = 0.0;

@interface OGInventoryBarNode ()

@property (nonatomic, strong) OGInventoryComponent *inventoryComponent;
@property (nonatomic, assign) CGFloat itemSizeLength;

@end

@implementation OGInventoryBarNode

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

- (void)update
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
    self.zPosition = OGZPositionCategoryForeground;
    
    self.itemSizeLength = height;
    [self updateItems];
}

- (void)updateItems
{
    [self removeAllChildren];
    
    if (self.inventoryComponent)
    {
        __weak typeof(self) weakSelf = self;
        
        [self.inventoryComponent.inventoryItems enumerateObjectsUsingBlock:^(id<OGInventoryItem>  item, NSUInteger idx, BOOL * _Nonnull stop) 
         {
             if (weakSelf)
             {
                 typeof(weakSelf) strongSelf = weakSelf;
                 
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
                     CGFloat xPosition = (self.itemSizeLength - self.size.width) / 2 + self.itemSizeLength * idx;
                     
                     itemNode.position = CGPointMake(xPosition, kOGInventoryBarNodeDefaultItemNodeYPosition);
                     
                     [strongSelf addChild:itemNode];
                 }
             }
         }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:kOGInventoryComponentInventoryItemsKeyPath])
    {
        [self updateItems];
    }
}

- (void)dealloc
{
    [_inventoryComponent removeObserver:self forKeyPath:kOGInventoryComponentInventoryItemsKeyPath];
}

@end
